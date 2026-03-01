//
//  ClassifierService.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import Foundation
import NaturalLanguage
import CoreML

/// Service that handles text classification using the Core ML model + NaturalLanguage framework
class ClassifierService: ObservableObject {
    
    private var nlModel: NLModel?
    private let tagger = NLTagger(tagSchemes: [.sentimentScore])
    private let tokenizer = NLTokenizer(unit: .word)
    
    /// Known harmful keywords/phrases per category (supplements ML predictions)
    private let harmfulPatterns: [ToneCategory: Set<String>] = [
        .bullying: ["stupid", "idiot", "loser", "ugly", "dumb", "pathetic", "worthless",
                     "shut up", "kill yourself", "nobody likes you", "freak", "trash"],
        .hateSpeed: ["slur", "go back to", "your kind", "don't belong"],
        .manipulation: ["if you really loved", "after everything i've done", "you owe me",
                        "no one else would", "you're nothing without", "it's your fault",
                        "i guess i'll just", "you made me"],
        .passiveAggression: ["must be nice", "i'm fine", "no worries", "good for you",
                             "whatever you say", "i'm not mad", "interesting choice"]
    ]
    
    init() {
        loadModel()
    }
    
    /// Load the Core ML model — tries multiple approaches
    private func loadModel() {
        let possibleNames = ["ToneClassifier", "ToneClassifier 1"]
        
        for name in possibleNames {
            // Try compiled .mlmodelc via NLModel
            if let modelURL = Bundle.main.url(forResource: name, withExtension: "mlmodelc") {
                // First try: load as MLModel, then wrap in NLModel
                // This gives us proper hypothesis/confidence support
                do {
                    let coreMLModel = try MLModel(contentsOf: modelURL)
                    let wrapped = try NLModel(mlModel: coreMLModel)
                    self.nlModel = wrapped
                    print("✅ Loaded via MLModel → NLModel from \(name).mlmodelc")
                    return
                } catch {
                    print("⚠️ MLModel→NLModel failed for \(name): \(error)")
                }
                
                // Second try: load directly as NLModel
                do {
                    self.nlModel = try NLModel(contentsOf: modelURL)
                    print("✅ Loaded NLModel directly from \(name).mlmodelc")
                    return
                } catch {
                    print("⚠️ Direct NLModel failed for \(name): \(error)")
                }
            }
        }
        
        print("⚠️ No model found in bundle — falling back to sentiment-only analysis")
    }
    
    /// Analyze a message and return a full result
    func analyze(_ text: String) -> AnalysisResult {
        let (category, confidence) = classifyWithConfidence(text)
        let sentiment = getSentimentScore(for: text)
        let flagged = findFlaggedWords(in: text, category: category)
        
        return AnalysisResult(
            originalText: text,
            category: category,
            confidence: confidence,
            sentimentScore: sentiment,
            flaggedWords: flagged,
            timestamp: Date()
        )
    }
    
    /// Classify text and return both category and confidence
    private func classifyWithConfidence(_ text: String) -> (ToneCategory, Double) {
        guard let model = nlModel else {
            // No model — fallback to sentiment
            let sentiment = getSentimentScore(for: text)
            if sentiment < -0.6 { return (.bullying, 0.6) }
            if sentiment < -0.3 { return (.passiveAggression, 0.5) }
            return (.healthy, 0.7)
        }
        
        // Get all hypotheses (label → probability)
        let hypotheses = model.predictedLabelHypotheses(for: text, maximumCount: 5)
        
        if !hypotheses.isEmpty {
            // Find the label with highest confidence
            if let best = hypotheses.max(by: { $0.value < $1.value }) {
                let category = ToneCategory(rawValue: best.key) ?? .healthy
                let confidence = best.value
                
                // Clamp to reasonable range — sometimes model returns very low values
                let clampedConfidence = max(0.3, min(1.0, confidence))
                return (category, clampedConfidence)
            }
        }
        
        // Hypotheses empty — just use predicted label with a default confidence
        if let label = model.predictedLabel(for: text) {
            let category = ToneCategory(rawValue: label) ?? .healthy
            // Use sentiment magnitude as a rough proxy for confidence
            let sentiment = abs(getSentimentScore(for: text))
            let estimatedConfidence = max(0.55, min(0.90, 0.5 + sentiment * 0.4))
            return (category, estimatedConfidence)
        }
        
        return (.healthy, 0.6)
    }
    
    /// Get sentiment score using NaturalLanguage framework (-1.0 to 1.0)
    func getSentimentScore(for text: String) -> Double {
        tagger.string = text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        return Double(sentiment?.rawValue ?? "0") ?? 0.0
    }
    
    /// Find words in the text that likely triggered the classification
    func findFlaggedWords(in text: String, category: ToneCategory) -> [String] {
        guard category != .healthy else { return [] }
        
        let lowercased = text.lowercased()
        var flagged: [String] = []
        
        // Check against known harmful patterns for the detected category
        if let patterns = harmfulPatterns[category] {
            for pattern in patterns {
                if lowercased.contains(pattern) {
                    flagged.append(pattern)
                }
            }
        }
        
        // Also check other categories' patterns
        for (cat, patterns) in harmfulPatterns where cat != category {
            for pattern in patterns {
                if lowercased.contains(pattern) {
                    flagged.append(pattern)
                }
            }
        }
        
        // If no pattern matches, flag words with negative sentiment
        if flagged.isEmpty {
            tokenizer.string = text
            tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
                let word = String(text[range])
                let wordSentiment = self.getSentimentScore(for: word)
                if wordSentiment < -0.3 {
                    flagged.append(word)
                }
                return true
            }
        }
        
        return Array(Set(flagged))
    }
}
