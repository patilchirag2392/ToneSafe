//
//  AnalyzeView.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

struct AnalyzeView: View {
    @EnvironmentObject var classifier: ClassifierService
    @State private var inputText = ""
    @State private var result: AnalysisResult?
    @State private var isAnalyzing = false
    @State private var showResult = false
    @FocusState private var isInputFocused: Bool
    
    private let examples: [(text: String, label: String)] = [
        ("You're such a loser, nobody even likes you", "Bullying"),
        ("If you really cared about me you wouldn't question this", "Manipulation"),
        ("Must be nice to have so much free time", "Passive Aggression"),
        ("People like you don't belong here", "Hate Speech"),
        ("Great job on the presentation today!", "Healthy"),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.tsBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        // Input Area
                        VStack(alignment: .leading, spacing: 10) {
                            Text("What message do you want to check?")
                                .font(.tsBody(15))
                                .foregroundStyle(.tsTextSecondary)
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $inputText)
                                    .focused($isInputFocused)
                                    .font(.tsBody(16))
                                    .foregroundStyle(.tsText)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 130)
                                    .padding(16)
                                    .background(Color.tsSurfaceElevated)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .shadow(color: isInputFocused ? Color.tsAccent.opacity(0.08) : .black.opacity(0.03), radius: isInputFocused ? 12 : 8, x: 0, y: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(isInputFocused ? Color.tsAccent.opacity(0.4) : Color.clear, lineWidth: 1.5)
                                    )
                                
                                if inputText.isEmpty {
                                    Text("Paste or type a message...")
                                        .font(.tsBody(16))
                                        .foregroundStyle(.tsTextTertiary)
                                        .padding(.leading, 21)
                                        .padding(.top, 24)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                        
                        // Analyze Button
                        Button {
                            analyzeMessage()
                        } label: {
                            HStack(spacing: 8) {
                                if isAnalyzing {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.9)
                                } else {
                                    Image(systemName: "waveform.and.magnifyingglass")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                Text(isAnalyzing ? "Analyzing..." : "Analyze")
                                    .font(.tsBody(16))
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    ? Color.tsTextTertiary
                                    : Color.tsAccent
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(
                                color: inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    ? .clear
                                    : Color.tsAccent.opacity(0.2),
                                radius: 12, x: 0, y: 6
                            )
                        }
                        .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isAnalyzing)
                        
                        // Divider
                        HStack(spacing: 12) {
                            Rectangle().fill(Color.tsSurface).frame(height: 1)
                            Text("or try an example")
                                .font(.tsCaption(12))
                                .foregroundStyle(.tsTextTertiary)
                                .layoutPriority(1)
                            Rectangle().fill(Color.tsSurface).frame(height: 1)
                        }
                        
                        // Example Messages
                        VStack(spacing: 8) {
                            ForEach(examples, id: \.text) { example in
                                Button {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        inputText = example.text
                                    }
                                    // Haptic
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                } label: {
                                    HStack {
                                        Text(example.text)
                                            .font(.tsBody(14))
                                            .foregroundStyle(.tsText)
                                            .lineLimit(1)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                        
                                        Text(example.label)
                                            .font(.tsCaption(11))
                                            .foregroundStyle(.tsTextTertiary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.tsSurface)
                                            .clipShape(Capsule())
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.tsSurfaceElevated)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Analyze")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $showResult) {
                if let result = result {
                    ResultView(result: result)
                }
            }
            .onTapGesture { isInputFocused = false }
        }
    }
    
    private func analyzeMessage() {
        isInputFocused = false
        isAnalyzing = true
        
        // Haptic
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            result = classifier.analyze(inputText)
            isAnalyzing = false
            
            // Success haptic
            let notif = UINotificationFeedbackGenerator()
            notif.notificationOccurred(result?.isHarmful == true ? .warning : .success)
            
            showResult = true
        }
    }
}
