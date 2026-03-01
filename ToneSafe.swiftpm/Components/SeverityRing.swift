//
//  SeverityRing.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

struct SeverityRing: View {
    let severity: Double  // 0.0 – 1.0
    let confidence: Double
    let category: ToneCategory
    @State private var animatedProgress: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color.tsSurface, lineWidth: 6)
                .frame(width: 120, height: 120)
            
            // Animated progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: [category.themeColor.opacity(0.3), category.themeColor],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(-90))
            
            // Inner content
            VStack(spacing: 2) {
                Text(category.emoji)
                    .font(.system(size: 28))
                
                Text("\(Int(confidence * 100))%")
                    .font(.tsMono(16))
                    .foregroundStyle(category.themeColor)
            }
            .scaleEffect(pulseScale)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.7).delay(0.2)) {
                animatedProgress = severity
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(1.0)) {
                pulseScale = 1.05
            }
        }
    }
}
