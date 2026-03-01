//
//  EmpathyView.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

// MARK: - Floating Particle

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var speed: CGFloat
}

@available(iOS 17.0, *)
struct ParticleField: View {
    @State private var particles: [Particle] = []
    let severity: Double
    let color: Color
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.05)) { timeline in
            Canvas { context, size in
                for particle in particles {
                    let rect = CGRect(
                        x: particle.x * size.width,
                        y: particle.y * size.height,
                        width: particle.size,
                        height: particle.size
                    )
                    context.opacity = particle.opacity
                    context.fill(Circle().path(in: rect), with: .color(color))
                }
            }
            .onChange(of: timeline.date) { _, _ in
                updateParticles()
            }
        }
        .onAppear {
            let count = Int(severity * 40) + 10
            particles = (0..<count).map { _ in
                Particle(
                    x: CGFloat.random(in: 0...1),
                    y: CGFloat.random(in: 0...1),
                    size: CGFloat.random(in: 1...4),
                    opacity: Double.random(in: 0.1...0.5),
                    speed: CGFloat.random(in: 0.001...0.005)
                )
            }
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            particles[i].y -= particles[i].speed
            particles[i].opacity *= 0.998
            if particles[i].y < 0 {
                particles[i].y = 1.0
                particles[i].x = CGFloat.random(in: 0...1)
                particles[i].opacity = Double.random(in: 0.1...0.5)
            }
        }
    }
}

// MARK: - Empathy View

struct EmpathyView: View {
    let result: AnalysisResult
    
    @State private var phase: EmpathyPhase = .intro
    @State private var textOpacity: Double = 0
    @State private var textScale: CGFloat = 1.0
    @State private var textWeight: Font.Weight = .regular
    @State private var shakeOffset: CGFloat = 0
    @State private var backgroundDarkness: Double = 0
    @State private var crackProgress: Double = 0
    @State private var breathe = false
    @State private var wordFragments: [WordFragment] = []
    @State private var showFragments = false
    @State private var visibleWordCount: Int = 0
    @State private var flashOpacity: Double = 0
    
    enum EmpathyPhase: Equatable {
        case intro, building, impact, shatter, reflection
    }
    
    struct WordFragment: Identifiable {
        let id = UUID()
        let text: String
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        var rotation: Double = 0
        var opacity: Double = 1.0
    }
    
    private var severity: Double {
        result.category.severity * result.confidence
    }
    
    var body: some View {
        ZStack {
            // Background layers
            backgroundLayer
            
            // Particles
            if #available(iOS 17.0, *) {
                if phase != .intro && phase != .reflection {
                    ParticleField(severity: severity, color: result.category.themeColor)
                        .opacity(phase == .shatter ? 0.8 : 0.4)
                        .ignoresSafeArea()
                }
            }
            
            // Screen flash on shatter
            Color.white
                .opacity(flashOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            // Content
            VStack {
                Spacer()
                contentForPhase
                Spacer()
                bottomContent
            }
            .padding(.horizontal, 28)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: - Background
    
    private var backgroundLayer: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: backgroundColors,
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Vignette overlay for dramatic effect
            RadialGradient(
                colors: [.clear, .black.opacity(backgroundDarkness * 0.5)],
                center: .center,
                startRadius: 100,
                endRadius: 400
            )
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 2.0), value: phase)
    }
    
    private var backgroundColors: [Color] {
        switch phase {
        case .intro:
            return [Color(red: 0.12, green: 0.13, blue: 0.22), Color(red: 0.08, green: 0.08, blue: 0.15)]
        case .building:
            return [Color(red: 0.15, green: 0.08, blue: 0.18), Color(red: 0.10, green: 0.04, blue: 0.10)]
        case .impact, .shatter:
            return [Color(red: 0.08, green: 0.03, blue: 0.08), .black]
        case .reflection:
            return [Color(red: 0.10, green: 0.12, blue: 0.20), Color(red: 0.06, green: 0.07, blue: 0.14)]
        }
    }
    
    // MARK: - Phase Content
    
    @ViewBuilder
    private var contentForPhase: some View {
        switch phase {
        case .intro:
            introContent
        case .building:
            buildingContent
        case .impact:
            impactContent
        case .shatter:
            shatterContent
        case .reflection:
            reflectionContent
        }
    }
    
    private var introContent: some View {
        VStack(spacing: 28) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 120, height: 120)
                    .scaleEffect(breathe ? 1.15 : 1.0)
                
                Circle()
                    .fill(Color.white.opacity(0.03))
                    .frame(width: 160, height: 160)
                    .scaleEffect(breathe ? 1.1 : 1.0)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 44, weight: .light))
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            VStack(spacing: 12) {
                Text("Empathy Mode")
                    .font(.tsDisplay(28))
                    .foregroundStyle(.white)
                
                Text("Step into the shoes of the\nperson receiving this message.")
                    .font(.tsBody(16))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                breathe = true
            }
        }
    }
    
    private var buildingContent: some View {
        VStack(spacing: 32) {
            // Typing effect — words appear one at a time
            TypingTextView(
                fullText: result.originalText,
                visibleWordCount: visibleWordCount
            )
            .font(.system(size: 22, weight: textWeight, design: .serif))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .lineSpacing(8)
            .scaleEffect(textScale)
            .offset(x: shakeOffset)
            .padding(.horizontal, 16)
            
            Text(emotionalContext)
                .font(.tsBody(14))
                .foregroundStyle(.white.opacity(0.4))
                .italic()
                .multilineTextAlignment(.center)
                .opacity(textOpacity * 0.8)
        }
    }
    
    private var impactContent: some View {
        VStack(spacing: 24) {
            ZStack {
                Image(systemName: "heart.slash.fill")
                    .font(.system(size: 72, weight: .ultraLight))
                    .foregroundStyle(result.category.themeColor.opacity(crackProgress))
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 72, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.2 * (1 - crackProgress)))
            }
            
            Text("This is how words land.")
                .font(.tsDisplay(22))
                .foregroundStyle(.white)
            
            Text(impactDescription)
                .font(.tsBody(15))
                .foregroundStyle(.white.opacity(0.55))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
        }
    }
    
    private var shatterContent: some View {
        ZStack {
            if showFragments {
                ForEach(wordFragments) { fragment in
                    Text(fragment.text)
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .foregroundStyle(.white.opacity(fragment.opacity))
                        .offset(x: fragment.offsetX, y: fragment.offsetY)
                        .rotationEffect(.degrees(fragment.rotation))
                }
            }
        }
        .frame(height: 200)
    }
    
    private var reflectionContent: some View {
        VStack(spacing: 24) {
            Image(systemName: "sun.max.fill")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(.yellow.opacity(0.8))
            
            Text("Words are powerful.")
                .font(.tsDisplay(24))
                .foregroundStyle(.white)
            
            VStack(spacing: 8) {
                Text("Detected: **\(result.category.displayName)** · \(Int(result.confidence * 100))% confidence")
                    .font(.tsBody(14))
                    .foregroundStyle(.white.opacity(0.6))
                
                Text("Before sending any message, ask:\n\"Would I want to receive this?\"")
                    .font(.tsBody(15))
                    .foregroundStyle(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.top, 8)
            }
        }
    }
    
    // MARK: - Bottom
    
    @ViewBuilder
    private var bottomContent: some View {
        switch phase {
        case .intro:
            Button {
                startSequence()
            } label: {
                Text("Begin")
                    .font(.tsBody(16))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(red: 0.12, green: 0.13, blue: 0.22))
                    .padding(.horizontal, 56)
                    .padding(.vertical, 16)
                    .background(.white)
                    .clipShape(Capsule())
            }
            .padding(.bottom, 50)
            
        case .reflection:
            Text("Go back to see healthier rewrites →")
                .font(.tsCaption(13))
                .foregroundStyle(.white.opacity(0.3))
                .padding(.bottom, 50)
            
        case .impact:
            Button {
                triggerShatter()
            } label: {
                Text("Let go")
                    .font(.tsCaption(14))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.08))
                    .clipShape(Capsule())
            }
            .padding(.bottom, 50)
            
        default:
            Spacer().frame(height: 50)
        }
    }
    
    // MARK: - Animation Sequence
    
    private func startSequence() {
        // Phase: Building
        withAnimation(.easeInOut(duration: 0.8)) { phase = .building }
        
        // Typing effect — words appear one by one
        let words = result.originalText.split(separator: " ")
        let typingDelay = 0.6
        for i in 0..<words.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + typingDelay + Double(i) * 0.18) {
                withAnimation(.easeOut(duration: 0.15)) {
                    visibleWordCount = i + 1
                }
                // Light haptic per word
                let tap = UIImpactFeedbackGenerator(style: .soft)
                tap.impactOccurred(intensity: 0.3)
            }
        }
        
        // Show context text after typing finishes
        let typingDuration = typingDelay + Double(words.count) * 0.18
        DispatchQueue.main.asyncAfter(deadline: .now() + typingDuration + 0.3) {
            withAnimation(.easeIn(duration: 0.8)) { textOpacity = 1.0 }
        }
        
        // Text gets heavier
        let heavyDelay = typingDuration + 0.8
        DispatchQueue.main.asyncAfter(deadline: .now() + heavyDelay) {
            withAnimation(.easeInOut(duration: 1.5)) {
                textWeight = severity > 0.6 ? .heavy : .semibold
                textScale = 1.0 + CGFloat(severity) * 0.1
                backgroundDarkness = severity * 0.6
            }
        }
        
        // Shake for high severity
        if severity > 0.4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + heavyDelay + 1.5) {
                shakeText()
                let impact = UIImpactFeedbackGenerator(style: .heavy)
                impact.impactOccurred()
            }
        }
        
        // Transition to impact
        DispatchQueue.main.asyncAfter(deadline: .now() + heavyDelay + 3.0) {
            let impact = UIImpactFeedbackGenerator(style: .rigid)
            impact.impactOccurred()
            
            withAnimation(.easeInOut(duration: 1.0)) { phase = .impact }
            withAnimation(.easeIn(duration: 2.0)) { crackProgress = 1.0 }
        }
    }
    
    private func triggerShatter() {
        // Create word fragments from original text
        let words = result.originalText.split(separator: " ").map(String.init)
        wordFragments = words.map { word in
            WordFragment(text: word)
        }
        
        withAnimation(.easeInOut(duration: 0.3)) { phase = .shatter }
        showFragments = true
        
        // Screen flash
        withAnimation(.easeIn(duration: 0.05)) { flashOpacity = 0.6 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.easeOut(duration: 0.4)) { flashOpacity = 0 }
        }
        
        // Scatter the fragments
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in wordFragments.indices {
                withAnimation(.easeOut(duration: 1.5).delay(Double(i) * 0.05)) {
                    wordFragments[i].offsetX = CGFloat.random(in: -200...200)
                    wordFragments[i].offsetY = CGFloat.random(in: -300...300)
                    wordFragments[i].rotation = Double.random(in: -180...180)
                    wordFragments[i].opacity = 0
                }
            }
        }
        
        // Haptic burst
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        
        // Transition to reflection
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 1.2)) { phase = .reflection }
        }
    }
    
    private func shakeText() {
        let intensity: CGFloat = CGFloat(severity) * 8
        let steps: [(CGFloat, Double)] = [
            (intensity, 0), (-intensity, 0.04), (intensity * 0.7, 0.08),
            (-intensity * 0.5, 0.12), (intensity * 0.3, 0.16), (0, 0.2)
        ]
        for (offset, delay) in steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.linear(duration: 0.04)) { shakeOffset = offset }
            }
        }
    }
    
    // MARK: - Content Strings
    
    private var emotionalContext: String {
        switch result.category {
        case .bullying: return "Imagine reading this as a teenager, alone in their room, at midnight."
        case .hateSpeed: return "Imagine this targeting who you are — not what you did."
        case .manipulation: return "Imagine hearing this from someone you trust with everything."
        case .passiveAggression: return "Imagine never knowing if they're joking or slowly breaking you."
        case .healthy: return ""
        }
    }
    
    private var impactDescription: String {
        switch result.category {
        case .bullying:
            return "Verbal attacks carve grooves in self-worth that can take years to fill. The person reading this doesn't just forget — they carry it."
        case .hateSpeed:
            return "Hate speech doesn't just hurt one person. It tells an entire community they're less than human. That weight is immeasurable."
        case .manipulation:
            return "Manipulative words erode reality itself. The person begins to doubt their own thoughts, feelings, and memories."
        case .passiveAggression:
            return "The cruelest part of passive aggression is plausible deniability. The pain is real, but it's designed to be undeniable."
        case .healthy:
            return ""
        }
    }
}
