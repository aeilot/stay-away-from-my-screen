//
//  HandTrackingManager.swift
//  stay-away-from-my-screen
//
//  Created for Vision-based hand tracking
//

import AVFoundation
import Vision
import AppKit
import Combine

class HandTrackingManager: NSObject, ObservableObject {
    
    static let shared = HandTrackingManager()
    
    @Published var isTracking = false
    private var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let videoQueue = DispatchQueue(label: "com.safms.videoQueue")
    
    private var lastHandDetectionTime: Date?
    private var handDetectionThreshold: TimeInterval = 0.3
    
    private var previousFingerTipY: CGFloat = 0
    private var stretchDetectionCount = 0
    private let stretchThreshold = 3
    
    private override init() {
        super.init()
    }
    
    func startTracking() {
        guard !isTracking else { return }
        
        // Request camera permission
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted else {
                print("❌ Camera access denied")
                return
            }
            
            DispatchQueue.main.async {
                self?.setupCaptureSession()
            }
        }
    }
    
    func stopTracking() {
        guard isTracking else { return }
        
        captureSession?.stopRunning()
        captureSession = nil
        videoOutput = nil
        isTracking = false
        print("✅ Hand tracking stopped")
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        
        captureSession.sessionPreset = .medium
        
        // Get front camera (FaceTime camera)
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("❌ Could not access camera")
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        } else {
            print("❌ Could not add camera input")
            return
        }
        
        videoOutput = AVCaptureVideoDataOutput()
        guard let videoOutput = videoOutput else { return }
        
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            print("❌ Could not add video output")
            return
        }
        
        // Start session on background thread
        videoQueue.async {
            captureSession.startRunning()
        }
        
        isTracking = true
        print("✅ Hand tracking started")
    }
    
    private func processHandObservations(_ observations: [VNHumanHandPoseObservation]) {
        guard let observation = observations.first else { return }
        
        // Get finger tip points
        guard let indexTip = try? observation.recognizedPoint(.indexTip),
              let middleTip = try? observation.recognizedPoint(.middleTip),
              let wrist = try? observation.recognizedPoint(.wrist),
              indexTip.confidence > 0.3,
              middleTip.confidence > 0.3,
              wrist.confidence > 0.3 else {
            return
        }
        
        // Calculate finger extension (distance from wrist to fingertip)
        let indexExtension = distance(from: wrist.location, to: indexTip.location)
        let middleExtension = distance(from: middleTip.location, to: middleTip.location)
        
        // Calculate average fingertip Y position (higher value = closer to screen/camera)
        let avgFingerY = (indexTip.location.y + middleTip.location.y) / 2
        
        // Detect stretching motion: fingers moving upward (toward screen)
        let yDelta = avgFingerY - previousFingerTipY
        
        // Threshold for detecting forward motion
        if yDelta > 0.02 && indexExtension > 0.15 {
            stretchDetectionCount += 1
            
            if stretchDetectionCount >= stretchThreshold {
                // Trigger the warning
                DispatchQueue.main.async {
                    self.triggerWarning()
                }
                stretchDetectionCount = 0
            }
        } else if yDelta < -0.01 {
            // Reset if hand is moving away
            stretchDetectionCount = max(0, stretchDetectionCount - 1)
        }
        
        previousFingerTipY = avgFingerY
    }
    
    private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func triggerWarning() {
        let now = Date()
        
        // Debounce: don't trigger too frequently
        if let lastTime = lastHandDetectionTime,
           now.timeIntervalSince(lastTime) < handDetectionThreshold {
            return
        }
        
        lastHandDetectionTime = now
        print("🖐️ Hand stretch detected! Triggering warning...")
        
        // Trigger the same notification as hotkey
        NotificationCenter.default.post(name: .hotKeyPressed, object: nil)
    }
}

extension HandTrackingManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectHumanHandPoseRequest { [weak self] request, error in
            guard let observations = request.results as? [VNHumanHandPoseObservation],
                  !observations.isEmpty else {
                return
            }
            
            self?.processHandObservations(observations)
        }
        
        // Configure to detect only one hand for better performance
        request.maximumHandCount = 1
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}
