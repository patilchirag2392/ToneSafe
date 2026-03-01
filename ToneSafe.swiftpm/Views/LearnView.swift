//
//  LearnView.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

struct LearnView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.tsBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Learn to Recognize")
                                .font(.tsTitle(22))
                                .foregroundStyle(.tsText)
                            Text("Understand harmful communication patterns")
                                .font(.tsBody(14))
                                .foregroundStyle(.tsTextSecondary)
                        }
                        .padding(.top, 10)
                        
                        // Lesson Cards
                        ForEach(lessons) { lesson in
                            NavigationLink(value: lesson) {
                                LessonCard(lesson: lesson)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Lesson.self) { lesson in
                LessonDetailView(lesson: lesson)
            }
        }
    }
}

// MARK: - Data

struct Lesson: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let description: String
    let examples: [LessonExample]
    let quiz: [QuizQuestion]
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Lesson, rhs: Lesson) -> Bool { lhs.id == rhs.id }
}

struct LessonExample: Identifiable {
    let id = UUID()
    let message: String
    let isHarmful: Bool
    let explanation: String
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let message: String
    let isHarmful: Bool
    let explanation: String
}

// MARK: - Lesson Content

let lessons: [Lesson] = [
    Lesson(
        title: "Bullying",
        icon: "👊",
        color: .tsDanger,
        description: "Direct personal attacks, insults, and threats designed to hurt or intimidate.",
        examples: [
            LessonExample(message: "You're such a loser, nobody even likes you.", isHarmful: true,
                         explanation: "This attacks someone's worth as a person and tries to isolate them by claiming nobody likes them."),
            LessonExample(message: "I disagree with your approach on this project.", isHarmful: false,
                         explanation: "This focuses on the work, not the person. Healthy disagreement is normal."),
            LessonExample(message: "Shut up, your opinion doesn't matter.", isHarmful: true,
                         explanation: "Silencing someone and devaluing their perspective is a form of verbal bullying."),
        ],
        quiz: [
            QuizQuestion(message: "You're so dumb, I can't believe you got that wrong.", isHarmful: true,
                        explanation: "This attacks intelligence over a mistake. Everyone makes mistakes — this is bullying."),
            QuizQuestion(message: "I think there might be a mistake here, want to double-check?", isHarmful: false,
                        explanation: "This points out an error without attacking the person. Constructive and respectful."),
            QuizQuestion(message: "Everyone would be happier if you just disappeared.", isHarmful: true,
                        explanation: "This is severe bullying that makes someone feel their existence is a burden. Deeply harmful."),
            QuizQuestion(message: "I need some space from this conversation right now.", isHarmful: false,
                        explanation: "Setting a boundary is healthy. This communicates a need without attacking anyone."),
        ]
    ),
    Lesson(
        title: "Manipulation",
        icon: "🎭",
        color: .tsWarning,
        description: "Guilt-tripping, gaslighting, and emotional pressure to control behavior.",
        examples: [
            LessonExample(message: "If you really loved me, you would do this for me.", isHarmful: true,
                         explanation: "This uses love as leverage. Healthy love doesn't come with conditions or tests."),
            LessonExample(message: "This is important to me. Can we talk about it?", isHarmful: false,
                         explanation: "This directly expresses a need without guilt or emotional pressure."),
            LessonExample(message: "After everything I've done for you, this is how you repay me?", isHarmful: true,
                         explanation: "Keeping score in relationships creates debt. This is guilt-tripping."),
        ],
        quiz: [
            QuizQuestion(message: "Nobody else would put up with you the way I do.", isHarmful: true,
                        explanation: "This undermines self-worth to create dependency. Classic manipulation."),
            QuizQuestion(message: "I appreciate your patience with me while I figure this out.", isHarmful: false,
                        explanation: "Expressing genuine gratitude without obligation is healthy communication."),
            QuizQuestion(message: "I guess I'll just suffer alone since nobody cares.", isHarmful: true,
                        explanation: "This guilt-trips by implying the listener is responsible for the speaker's suffering."),
            QuizQuestion(message: "I'm having a hard time and could really use some support.", isHarmful: false,
                        explanation: "Directly asking for support without guilt or pressure. Honest and vulnerable."),
        ]
    ),
    Lesson(
        title: "Passive Aggression",
        icon: "😒",
        color: .tsCaution,
        description: "Expressing negativity indirectly through sarcasm, backhanded compliments, or subtle hostility.",
        examples: [
            LessonExample(message: "Must be nice to have so much free time.", isHarmful: true,
                         explanation: "This disguises resentment or jealousy as a casual observation. The real feeling is hidden."),
            LessonExample(message: "I'm feeling a bit envious — I wish I had more free time too.", isHarmful: false,
                         explanation: "Naming the real emotion (envy) is honest and opens dialogue instead of creating tension."),
            LessonExample(message: "No worries, I'll just do it myself. Like always.", isHarmful: true,
                         explanation: "This martyrdom disguises a request for help as resigned suffering."),
        ],
        quiz: [
            QuizQuestion(message: "I'm sure you tried your best. That's what counts, right?", isHarmful: true,
                        explanation: "The sarcastic tone implies their best wasn't good enough. It's criticism dressed as encouragement."),
            QuizQuestion(message: "I could really use your help with this — would you have time?", isHarmful: false,
                        explanation: "Direct, clear, and respectful. No hidden meaning."),
            QuizQuestion(message: "Oh you actually remembered to do it this time, nice.", isHarmful: true,
                        explanation: "Backhanded acknowledgment that implies they usually forget. Subtle hostility."),
            QuizQuestion(message: "Thanks for handling that, it really helped.", isHarmful: false,
                        explanation: "Sincere gratitude with no sarcasm. Straightforward and kind."),
        ]
    ),
    Lesson(
        title: "Hate Speech",
        icon: "🚫",
        color: .tsSevere,
        description: "Language targeting someone based on identity — race, gender, religion, orientation, or other characteristics.",
        examples: [
            LessonExample(message: "People like you don't belong here.", isHarmful: true,
                         explanation: "This excludes someone based on who they are, not what they've done. Everyone belongs."),
            LessonExample(message: "I have a different perspective and I'd like to share it.", isHarmful: false,
                         explanation: "Disagreement without targeting identity is healthy discourse."),
            LessonExample(message: "Your kind is the problem with this country.", isHarmful: true,
                         explanation: "Blaming an entire group for complex problems dehumanizes individuals."),
        ],
        quiz: [
            QuizQuestion(message: "Go back to where you came from.", isHarmful: true,
                        explanation: "This denies someone's right to be in a space based on perceived origin. It's exclusionary and harmful."),
            QuizQuestion(message: "I'd love to learn more about your cultural traditions.", isHarmful: false,
                        explanation: "Genuine curiosity about differences builds understanding and connection."),
            QuizQuestion(message: "You people are all the same.", isHarmful: true,
                        explanation: "Generalizing an entire group erases individual humanity. This is dehumanizing."),
            QuizQuestion(message: "I see things differently, but I respect your perspective.", isHarmful: false,
                        explanation: "Disagreement with respect. You can hold different views without attacking identity."),
        ]
    ),
]

// MARK: - Lesson Card

struct LessonCard: View {
    let lesson: Lesson
    
    var body: some View {
        HStack(spacing: 16) {
            Text(lesson.icon)
                .font(.system(size: 30))
                .frame(width: 52, height: 52)
                .background(lesson.color.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(.tsBody(16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.tsText)
                
                Text(lesson.description)
                    .font(.tsCaption(12))
                    .foregroundStyle(.tsTextSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.tsTextTertiary)
        }
        .padding(16)
        .background(Color.tsSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Lesson Detail

struct LessonDetailView: View {
    let lesson: Lesson
    @State private var showQuiz = false
    
    var body: some View {
        ZStack {
            Color.tsBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 10) {
                        Text(lesson.icon)
                            .font(.system(size: 44))
                        Text(lesson.title)
                            .font(.tsDisplay(26))
                            .foregroundStyle(.tsText)
                        Text(lesson.description)
                            .font(.tsBody(15))
                            .foregroundStyle(.tsTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.top, 10)
                    
                    // Examples
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(lesson.color)
                                .frame(width: 3, height: 16)
                                .clipShape(Capsule())
                            Text("Examples")
                                .font(.tsCaption(12))
                                .fontWeight(.bold)
                                .foregroundStyle(lesson.color)
                                .textCase(.uppercase)
                                .tracking(0.8)
                        }
                        
                        ForEach(lesson.examples) { example in
                            ExampleCard(example: example)
                        }
                    }
                    
                    // Quiz Button
                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        showQuiz = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 18))
                            Text("Test Your Knowledge")
                                .font(.tsBody(16))
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.tsAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: Color.tsAccent.opacity(0.2), radius: 12, x: 0, y: 6)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showQuiz) {
            QuizView(questions: lesson.quiz, lessonTitle: lesson.title)
        }
    }
}

struct ExampleCard: View {
    let example: LessonExample
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Circle()
                    .fill(example.isHarmful ? Color.tsDanger : Color.tsHealthy)
                    .frame(width: 8, height: 8)
                Text(example.isHarmful ? "Harmful" : "Healthy")
                    .font(.tsCaption(11))
                    .fontWeight(.bold)
                    .foregroundStyle(example.isHarmful ? .tsDanger : .tsHealthy)
                    .textCase(.uppercase)
                    .tracking(0.6)
            }
            
            Text("\"\(example.message)\"")
                .font(.tsBody(15))
                .foregroundStyle(.tsText)
                .italic()
                .lineSpacing(3)
            
            Text(example.explanation)
                .font(.tsCaption(13))
                .foregroundStyle(.tsTextSecondary)
                .lineSpacing(3)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            example.isHarmful
                ? Color.tsDanger.opacity(0.04)
                : Color.tsHealthy.opacity(0.04)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    example.isHarmful ? Color.tsDanger.opacity(0.08) : Color.tsHealthy.opacity(0.08),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Quiz

struct QuizView: View {
    let questions: [QuizQuestion]
    let lessonTitle: String
    @Environment(\.dismiss) var dismiss
    @State private var currentIndex = 0
    @State private var selectedAnswer: Bool?
    @State private var showExplanation = false
    @State private var score = 0
    @State private var quizComplete = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.tsBackground.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    if quizComplete {
                        quizResults
                    } else {
                        quizQuestion
                    }
                }
                .padding(20)
            }
            .navigationTitle("\(lessonTitle) Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(.tsTextSecondary)
                }
            }
        }
    }
    
    private var quizResults: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: score == questions.count ? "star.fill" : "checkmark.circle.fill")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(score == questions.count ? .yellow : .tsHealthy)
            
            Text("Quiz Complete!")
                .font(.tsDisplay(24))
                .foregroundStyle(.tsText)
            
            Text("\(score) out of \(questions.count) correct")
                .font(.tsBody(16))
                .foregroundStyle(.tsTextSecondary)
            
            Spacer()
            
            Button("Done") {
                let impact = UINotificationFeedbackGenerator()
                impact.notificationOccurred(.success)
                dismiss()
            }
            .font(.tsBody(16))
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.tsAccent)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
    
    private var quizQuestion: some View {
        let question = questions[currentIndex]
        
        return VStack(spacing: 24) {
            // Progress
            HStack(spacing: 4) {
                ForEach(0..<questions.count, id: \.self) { i in
                    Capsule()
                        .fill(i == currentIndex ? Color.tsAccent : Color.tsSurface)
                        .frame(height: 4)
                }
            }
            
            Spacer()
            
            // Message
            Text("\"\(question.message)\"")
                .font(.system(size: 20, weight: .regular, design: .serif))
                .foregroundStyle(.tsText)
                .italic()
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal)
            
            Text("Is this message harmful?")
                .font(.tsBody(15))
                .foregroundStyle(.tsTextSecondary)
            
            // Answer Buttons
            HStack(spacing: 14) {
                quizAnswerButton(label: "Harmful", isHarmful: true, question: question)
                quizAnswerButton(label: "Healthy", isHarmful: false, question: question)
            }
            
            // Explanation
            if showExplanation {
                VStack(spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: selectedAnswer == question.isHarmful ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(selectedAnswer == question.isHarmful ? .tsHealthy : .tsDanger)
                        Text(selectedAnswer == question.isHarmful ? "Correct!" : "Not quite")
                            .font(.tsBody(15))
                            .fontWeight(.semibold)
                            .foregroundStyle(selectedAnswer == question.isHarmful ? .tsHealthy : .tsDanger)
                    }
                    
                    Text(question.explanation)
                        .font(.tsBody(14))
                        .foregroundStyle(.tsTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(20)
                .background(Color.tsSurfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 3)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                
                Button("Next") {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    withAnimation {
                        if currentIndex < questions.count - 1 {
                            currentIndex += 1
                            selectedAnswer = nil
                            showExplanation = false
                        } else {
                            quizComplete = true
                        }
                    }
                }
                .font(.tsBody(15))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.tsAccent)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            
            Spacer()
        }
    }
    
    private func quizAnswerButton(label: String, isHarmful: Bool, question: QuizQuestion) -> some View {
        Button {
            guard selectedAnswer == nil else { return }
            selectedAnswer = isHarmful
            
            let isCorrect = isHarmful == question.isHarmful
            if isCorrect { score += 1 }
            
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(isCorrect ? .success : .error)
            
            withAnimation(.easeOut(duration: 0.3)) {
                showExplanation = true
            }
        } label: {
            VStack(spacing: 8) {
                Image(systemName: isHarmful ? "xmark.circle" : "checkmark.circle")
                    .font(.system(size: 24, weight: .light))
                Text(label)
                    .font(.tsBody(15))
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 22)
            .background(buttonBackground(isHarmful: isHarmful, question: question))
            .foregroundStyle(buttonForeground(isHarmful: isHarmful, question: question))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(buttonBorder(isHarmful: isHarmful, question: question), lineWidth: 1.5)
            )
        }
        .disabled(selectedAnswer != nil)
    }
    
    private func buttonBackground(isHarmful: Bool, question: QuizQuestion) -> Color {
        guard let selected = selectedAnswer, selected == isHarmful else {
            return Color.tsSurfaceElevated
        }
        return isHarmful == question.isHarmful ? Color.tsHealthy.opacity(0.08) : Color.tsDanger.opacity(0.08)
    }
    
    private func buttonForeground(isHarmful: Bool, question: QuizQuestion) -> Color {
        guard let selected = selectedAnswer, selected == isHarmful else {
            return isHarmful ? .tsDanger : .tsHealthy
        }
        return isHarmful == question.isHarmful ? .tsHealthy : .tsDanger
    }
    
    private func buttonBorder(isHarmful: Bool, question: QuizQuestion) -> Color {
        guard let selected = selectedAnswer, selected == isHarmful else {
            return Color.tsSurface
        }
        return isHarmful == question.isHarmful ? .tsHealthy.opacity(0.3) : .tsDanger.opacity(0.3)
    }
}
