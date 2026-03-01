//
//  OnboardingView.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var animateIn = false
    @State private var typingText = ""
    @State private var showCursor = true
    
    private let pages: [(icon: String, title: String, subtitle: String, detail: String)] = [
        (
            "message.fill",
            "Words carry weight",
            "Every message you send\nhas the power to build\nsomeone up — or tear\nthem down.",
            ""
        ),
        (
            "waveform.path",
            "See beyond the surface",
            "ToneSafe uses machine learning to detect bullying, manipulation, hate speech, and passive aggression — right on your device.",
            ""
        ),
        (
            "heart.circle",
            "Feel the impact",
            "Our Empathy Mode lets you experience how harmful words feel to the person receiving them.",
            ""
        ),
        (
            "arrow.triangle.2.circlepath",
            "Learn to do better",
            "Get healthier rewrites that keep your intent but lose the harm. Because better communication starts with awareness.",
            ""
        )
    ]
    
    var body: some View {
        ZStack {
            Color.tsBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        pageView(for: index)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                Spacer()
                
                // Bottom section
                VStack(spacing: 20) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? Color.tsAccent : Color.tsTextTertiary.opacity(0.3))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    // Button
                    Button {
                        if currentPage < pages.count - 1 {
                            withAnimation { currentPage += 1 }
                        } else {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                hasCompletedOnboarding = true
                            }
                        }
                    } label: {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.tsBody(17))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.tsAccent)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    
                    // Skip
                    if currentPage < pages.count - 1 {
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                hasCompletedOnboarding = true
                            }
                        } label: {
                            Text("Skip")
                                .font(.tsCaption(15))
                                .foregroundStyle(.tsTextTertiary)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
    
    @ViewBuilder
    private func pageView(for index: Int) -> some View {
        let page = pages[index]
        
        VStack(spacing: 24) {
            // Icon with animated ring
            ZStack {
                Circle()
                    .stroke(Color.tsAccent.opacity(0.1), lineWidth: 2)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: currentPage == index ? 1 : 0)
                    .stroke(Color.tsAccent.opacity(0.3), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: currentPage)
                
                Image(systemName: page.icon)
                    .font(.system(size: 36))
                    .foregroundStyle(Color.tsAccent)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.tsDisplay(28))
                    .foregroundStyle(.tsText)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.tsBody(17))
                    .foregroundStyle(.tsTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 32)
        }
    }
}
