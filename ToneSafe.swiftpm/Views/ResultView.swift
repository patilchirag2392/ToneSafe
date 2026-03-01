//
//  ResultView.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

struct ResultView: View {
    let result: AnalysisResult
    @State private var animateIn = false
    @State private var showEmpathy = false
    @State private var showRewrite = false
    
    var body: some View {
        ZStack {
            Color.tsBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    // Severity Ring
                    SeverityRing(
                        severity: result.category.severity * result.confidence,
                        confidence: result.confidence,
                        category: result.category
                    )
                    .padding(.top, 16)
                    .opacity(animateIn ? 1 : 0)
                    .scaleEffect(animateIn ? 1 : 0.8)
                    
                    // Classification Label
                    VStack(spacing: 8) {
                        Text(result.category.displayName)
                            .font(.tsTitle(24))
                            .foregroundStyle(result.category.themeColor)
                        
                        Text(result.severityLevel)
                            .font(.tsCaption(13))
                            .fontWeight(.semibold)
                            .foregroundStyle(.tsTextTertiary)
                            .textCase(.uppercase)
                            .tracking(1.0)
                    }
                    .opacity(animateIn ? 1 : 0)
                    
                    // Description
                    Text(result.category.description)
                        .font(.tsBody(15))
                        .foregroundStyle(.tsTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .padding(.horizontal, 8)
                        .opacity(animateIn ? 1 : 0)
                    
                    // Original Message
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(result.category.themeColor)
                                .frame(width: 3, height: 16)
                                .clipShape(Capsule())
                            
                            Text("Original Message")
                                .font(.tsCaption(12))
                                .fontWeight(.bold)
                                .foregroundStyle(.tsTextTertiary)
                                .textCase(.uppercase)
                                .tracking(0.8)
                        }
                        
                        HighlightedTextView(
                            text: result.originalText,
                            flaggedWords: result.flaggedWords
                        )
                        .font(.tsBody(15))
                        .lineSpacing(4)
                    }
                    .tsCard()
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 15)
                    
                    // Action Buttons
                    if result.isHarmful {
                        VStack(spacing: 12) {
                            // Empathy Mode — primary CTA
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showEmpathy = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "heart.circle.fill")
                                        .font(.system(size: 20))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Feel the Impact")
                                            .font(.tsBody(16))
                                            .fontWeight(.semibold)
                                        Text("Experience how this message feels")
                                            .font(.tsCaption(12))
                                            .opacity(0.8)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundStyle(.white)
                                .padding(18)
                                .background(
                                    LinearGradient(
                                        colors: [Color(red: 0.15, green: 0.12, blue: 0.30), Color(red: 0.25, green: 0.10, blue: 0.35)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(red: 0.20, green: 0.10, blue: 0.30).opacity(0.3), radius: 16, x: 0, y: 8)
                            }
                            
                            // Rewrite — secondary CTA
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                showRewrite = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.system(size: 18))
                                    Text("See a Healthier Rewrite")
                                        .font(.tsBody(15))
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                                .foregroundStyle(.tsAccent)
                                .padding(18)
                                .background(Color.tsAccentSoft)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.tsAccent.opacity(0.15), lineWidth: 1)
                                )
                            }
                        }
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 20)
                    } else {
                        // Healthy celebration
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(.tsHealthy)
                            
                            Text("This message looks great!")
                                .font(.tsTitle(18))
                                .foregroundStyle(.tsHealthy)
                            
                            Text("Keep communicating with respect and empathy.")
                                .font(.tsBody(14))
                                .foregroundStyle(.tsTextSecondary)
                        }
                        .tsCard()
                        .opacity(animateIn ? 1 : 0)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showEmpathy) {
            EmpathyView(result: result)
        }
        .navigationDestination(isPresented: $showRewrite) {
            RewriteView(result: result)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.1)) {
                animateIn = true
            }
        }
    }
}
