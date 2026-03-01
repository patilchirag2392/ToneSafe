//
//  RewriteView.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

struct RewriteView: View {
    let result: AnalysisResult
    @State private var suggestion: RewriteSuggestion?
    @State private var animateIn = false
    @State private var showRewrite = false
    
    private let rewriteService = RewriteService()
    
    var body: some View {
        ZStack {
            Color.tsBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 32, weight: .light))
                            .foregroundStyle(Color.tsAccent)
                        
                        Text("Better words,\nsame meaning.")
                            .font(.tsDisplay(24))
                            .foregroundStyle(.tsText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 10)
                    .opacity(animateIn ? 1 : 0)
                    
                    if let suggestion = suggestion {
                        // Original
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.tsDanger)
                                    .frame(width: 8, height: 8)
                                Text("Before")
                                    .font(.tsCaption(12))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.tsDanger)
                                    .textCase(.uppercase)
                                    .tracking(0.8)
                            }
                            
                            Text(suggestion.original)
                                .font(.tsBody(15))
                                .foregroundStyle(.tsText)
                                .lineSpacing(4)
                                .italic()
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.tsDanger.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.tsDanger.opacity(0.1), lineWidth: 1)
                        )
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 15)
                        
                        // Animated arrow
                        Image(systemName: "arrow.down")
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(.tsTextTertiary)
                            .opacity(animateIn ? 1 : 0)
                        
                        // Rewrite — appears with a slight delay
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.tsHealthy)
                                    .frame(width: 8, height: 8)
                                Text("After")
                                    .font(.tsCaption(12))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.tsHealthy)
                                    .textCase(.uppercase)
                                    .tracking(0.8)
                            }
                            
                            Text(suggestion.rewrite)
                                .font(.tsBody(15))
                                .foregroundStyle(.tsText)
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.tsHealthy.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.tsHealthy.opacity(0.1), lineWidth: 1)
                        )
                        .opacity(showRewrite ? 1 : 0)
                        .offset(y: showRewrite ? 0 : 15)
                        
                        // Why it works
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Rectangle()
                                    .fill(Color.tsCaution)
                                    .frame(width: 3, height: 16)
                                    .clipShape(Capsule())
                                
                                Text("Why this works")
                                    .font(.tsCaption(12))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.tsCaution)
                                    .textCase(.uppercase)
                                    .tracking(0.8)
                            }
                            
                            Text(suggestion.explanation)
                                .font(.tsBody(15))
                                .foregroundStyle(.tsTextSecondary)
                                .lineSpacing(5)
                        }
                        .tsCard()
                        .opacity(showRewrite ? 1 : 0)
                        
                        // Key principle
                        VStack(spacing: 8) {
                            Text("Key Insight")
                                .font(.tsCaption(12))
                                .fontWeight(.bold)
                                .foregroundStyle(Color.tsAccent)
                                .textCase(.uppercase)
                                .tracking(0.8)
                            
                            Text(keyPrinciple)
                                .font(.tsBody(14))
                                .foregroundStyle(.tsTextSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(5)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.tsAccentSoft)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .opacity(showRewrite ? 1 : 0)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Rewrite")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            suggestion = rewriteService.suggest(for: result.originalText, category: result.category)
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) { animateIn = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) { showRewrite = true }
        }
    }
    
    private var keyPrinciple: String {
        switch result.category {
        case .bullying:
            return "Address the situation, never the person's worth. Strong words can be honest without being cruel."
        case .hateSpeed:
            return "Every person's identity is valid. Disagree with ideas, never with someone's right to exist."
        case .manipulation:
            return "Ask for what you need directly. Trust built on guilt isn't trust — it's control."
        case .passiveAggression:
            return "Say what you mean. Indirect hostility poisons slowly; direct honesty heals quickly."
        case .healthy:
            return "This is already great communication. Keep it up."
        }
    }
}
