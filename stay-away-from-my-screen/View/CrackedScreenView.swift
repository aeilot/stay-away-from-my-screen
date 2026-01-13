//
//  CrackedScreenView.swift
//  stay-away-from-my-screen
//
//  Created for cracked screen effect
//

import SwiftUI
import AppKit

struct CrackedScreenView: View {
    let crackOrigin: CGPoint
    
    // Increased ray count for a denser network
    let rayCount: Int = 22
    
    var body: some View {
        ZStack {
            // Subtle flash background to simulate LCD bleeding/layer separation
            Color.white.opacity(0.05)
                .ignoresSafeArea()
            
            Canvas { context, size in
                // 1. Draw the "Pulverized" Center (High Density)
                // This draws a solid white mess at the impact point
                drawImpactZone(context: context)

                // 2. Generate Main Fracture Rays (The long lines)
                var rays: [[CGPoint]] = []
                
                for i in 0..<rayCount {
                    // Distribute angles but add randomness so it's not a perfect wheel
                    let baseAngle = (Double(i) / Double(rayCount)) * 2 * .pi
                    let jitteredAngle = baseAngle + Double.random(in: -0.15...0.15)
                    
                    let points = generateJaggedRay(origin: crackOrigin, angle: jitteredAngle, size: size)
                    rays.append(points)
                }
                
                // 3. Render the Rays
                // We use a separate path for rays to give them a distinct sharp style
                let rayPath = Path { p in
                    for ray in rays {
                        guard let start = ray.first else { continue }
                        p.move(to: crackOrigin)
                        p.addLine(to: start)
                        
                        for point in ray.dropFirst() {
                            p.addLine(to: point)
                        }
                    }
                }
                
                context.stroke(
                    rayPath,
                    with: .color(.white.opacity(0.9)),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .butt, lineJoin: .miter)
                )
                
                // 4. Draw the "Spiked" Webbing (The connections between rays)
                // Instead of straight lines, we add jagged spikes to connections
                drawSpikedWebbing(context: context, rays: rays)
                
                // 5. Draw Sharp Debris (Floating shards)
                drawDebris(context: context)
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Drawing Logic
    
    /// Draws the ultra-dense white core at the impact site
    private func drawImpactZone(context: GraphicsContext) {
        // A. The "Bruise" (Glow)
        let glowPath = Path(ellipseIn: CGRect(x: crackOrigin.x - 30, y: crackOrigin.y - 30, width: 60, height: 60))
        context.fill(glowPath, with: .color(.white.opacity(0.2)))
        
        // B. The "Crush" (High density chaos)
        let crushPath = Path { p in
            // Loop 150 times to create a solid white mesh in the center
            for _ in 0..<150 {
                // Pick a random point very close to center
                let r = CGFloat.random(in: 0...20)
                let a = Double.random(in: 0...(2 * .pi))
                let startX = crackOrigin.x + cos(a) * r
                let startY = crackOrigin.y + sin(a) * r
                
                p.move(to: CGPoint(x: startX, y: startY))
                
                // Draw a short, sharp line from there
                let r2 = r + CGFloat.random(in: 2...10)
                let endX = crackOrigin.x + cos(a) * r2
                let endY = crackOrigin.y + sin(a) * r2
                
                p.addLine(to: CGPoint(x: endX, y: endY))
            }
        }
        
        // Stroke with high opacity to look like crushed glass powder
        context.stroke(crushPath, with: .color(.white.opacity(0.9)), lineWidth: 1.5)
    }
    
    /// Generates a ray that zig-zags outwards (not straight)
    private func generateJaggedRay(origin: CGPoint, angle: Double, size: CGSize) -> [CGPoint] {
        var points: [CGPoint] = []
        var currentDist: CGFloat = 15.0
        
        // Calculate max distance to corner of screen
        let maxDist = hypot(size.width, size.height)
        
        while currentDist < maxDist {
            // 1. Calculate ideal position
            let idealX = origin.x + cos(angle) * currentDist
            let idealY = origin.y + sin(angle) * currentDist
            
            // 2. Add "Spike" Deviation (Perpendicular jitter)
            // As distance increases, the jitter gets wilder
            let jitterMax = currentDist * 0.12
            let jitterX = CGFloat.random(in: -jitterMax...jitterMax)
            let jitterY = CGFloat.random(in: -jitterMax...jitterMax)
            
            points.append(CGPoint(x: idealX + jitterX, y: idealY + jitterY))
            
            // 3. Random step size (Keep steps short for more jaggedness)
            currentDist += CGFloat.random(in: 15...45)
        }
        return points
    }
    
    /// Connects the rays with sharp, triangular shards
    private func drawSpikedWebbing(context: GraphicsContext, rays: [[CGPoint]]) {
        let webPath = Path { p in
            for i in 0..<rays.count {
                let currentRay = rays[i]
                let nextRay = rays[(i + 1) % rays.count] // Wrap around
                
                let limit = min(currentRay.count, nextRay.count)
                
                for j in 0..<limit {
                    // Randomly skip connections (glass doesn't connect everywhere)
                    // Higher probability to connect near the center (j is low)
                    let probability = j < 5 ? 0.7 : 0.4
                    
                    if Double.random(in: 0...1) < probability {
                        let p1 = currentRay[j]
                        let p2 = nextRay[j]
                        
                        // KEY CHANGE: Don't draw straight line p1 -> p2.
                        // Draw p1 -> Spikey Midpoint -> p2
                        
                        let midX = (p1.x + p2.x) / 2
                        let midY = (p1.y + p2.y) / 2
                        
                        // Calculate a "spike" offset
                        // This makes the webbing look like triangles/shards
                        let spikeX = CGFloat.random(in: -10...10)
                        let spikeY = CGFloat.random(in: -10...10)
                        let spikePoint = CGPoint(x: midX + spikeX, y: midY + spikeY)
                        
                        p.move(to: p1)
                        p.addLine(to: spikePoint)
                        p.addLine(to: p2)
                        
                        // Occasionally close the triangle to form a solid chip
                        if Double.random(in: 0...1) > 0.8 {
                            p.closeSubpath()
                        }
                    }
                }
            }
        }
        
        context.stroke(
            webPath,
            with: .color(.white.opacity(0.7)),
            style: StrokeStyle(lineWidth: 0.8, lineCap: .square, lineJoin: .miter)
        )
    }
    
    /// Draws independent sharp floating triangles
    private func drawDebris(context: GraphicsContext) {
        let debrisPath = Path { p in
            // Draw 50+ random shards
            for _ in 0..<50 {
                // Concentrate debris near the center
                let dist = CGFloat.random(in: 10...150)
                let angle = Double.random(in: 0...(2 * .pi))
                
                let x = crackOrigin.x + cos(angle) * dist
                let y = crackOrigin.y + sin(angle) * dist
                
                p.move(to: CGPoint(x: x, y: y))
                
                // Draw a small sharp triangle
                p.addLine(to: CGPoint(x: x + CGFloat.random(in: -4...4), y: y + CGFloat.random(in: -4...4)))
                p.addLine(to: CGPoint(x: x + CGFloat.random(in: -4...4), y: y + CGFloat.random(in: -4...4)))
                p.closeSubpath()
            }
        }
        
        context.fill(debrisPath, with: .color(.white.opacity(0.7)))
    }
}

class CrackedScreenPanel: NSPanel {
    static var shared: CrackedScreenPanel?
    
    static func show(at location: CGPoint) {
        // Close existing panel if any
        shared?.orderOut(nil)
        shared = nil
        
        let panel = CrackedScreenPanel(crackOrigin: location)
        shared = panel
        panel.makeKeyAndOrderFront(nil)
    }
    
    static func hide() {
        shared?.orderOut(nil)
        shared = nil
    }
    
    init(crackOrigin: CGPoint) {
        guard let screen = NSScreen.main else {
            super.init(
                contentRect: .zero,
                styleMask: .borderless,
                backing: .buffered,
                defer: false
            )
            return
        }
        
        let screenFrame = screen.frame
        
        super.init(
            contentRect: screenFrame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        self.level = .statusBar
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        self.isFloatingPanel = true
        self.hidesOnDeactivate = false
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = false
        self.ignoresMouseEvents = true
        
        // Convert screen coordinates to window coordinates
        let windowOrigin = CGPoint(
            x: crackOrigin.x - screenFrame.origin.x,
            y: screenFrame.height - (crackOrigin.y - screenFrame.origin.y)
        )
        
        let crackView = CrackedScreenView(crackOrigin: windowOrigin)
        self.contentView = NSHostingView(rootView: crackView)
        
        // Auto-dismiss after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            CrackedScreenPanel.hide()
        }
    }
    
    override var canBecomeKey: Bool {
        return false
    }
    
    override var canBecomeMain: Bool {
        return false
    }
}
