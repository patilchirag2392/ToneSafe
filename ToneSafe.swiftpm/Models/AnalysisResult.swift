//
//  AnalysisResult.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import Foundation

/// Categories the classifier can detect
enum ToneCategory: String, CaseIterable, Identifiable {
    case bullying
    case hateSpeed = "hate_speech"
    case manipulation
    case passiveAggression = "passive_aggression"
    case healthy
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .bullying: return "Bullying"
        case .hateSpeed: return "Hate Speech"
        case .manipulation: return "Manipulation"
        case .passiveAggression: return "Passive Aggression"
        case .healthy: return "Healthy"
        }
    }
    
    var emoji: String {
        switch self {
        case .bullying: return "👊"
        case .hateSpeed: return "🚫"
        case .manipulation: return "🎭"
        case .passiveAggression: return "😒"
        case .healthy: return "💚"
        }
    }
    
    var description: String {
        switch self {
        case .bullying:
            return "This message contains direct personal attacks, insults, or threats intended to intimidate or hurt someone."
        case .hateSpeed:
            return "This message targets someone based on their identity, including race, gender, religion, or other protected characteristics."
        case .manipulation:
            return "This message uses guilt-tripping, gaslighting, or emotional pressure to control someone's behavior or feelings."
        case .passiveAggression:
            return "This message expresses negativity indirectly through sarcasm, backhanded compliments, or subtle hostility."
        case .healthy:
            return "This message appears to be respectful and constructive communication."
        }
    }
    
    /// Severity from 0 (healthy) to 1 (most harmful) — used for Empathy Mode visuals
    var severity: Double {
        switch self {
        case .healthy: return 0.0
        case .passiveAggression: return 0.4
        case .manipulation: return 0.6
        case .bullying: return 0.8
        case .hateSpeed: return 1.0
        }
    }
    
    var color: String {
        switch self {
        case .healthy: return "green"
        case .passiveAggression: return "yellow"
        case .manipulation: return "orange"
        case .bullying: return "red"
        case .hateSpeed: return "purple"
        }
    }
}

/// Result of analyzing a single message
struct AnalysisResult: Identifiable {
    let id = UUID()
    let originalText: String
    let category: ToneCategory
    let confidence: Double          // 0.0 – 1.0
    let sentimentScore: Double      // -1.0 (negative) to 1.0 (positive)
    let flaggedWords: [String]      // Words/phrases that triggered classification
    let timestamp: Date
    
    var isHarmful: Bool {
        category != .healthy
    }
    
    var severityLevel: String {
        let s = category.severity * confidence
        switch s {
        case 0..<0.2: return "Minimal"
        case 0.2..<0.4: return "Mild"
        case 0.4..<0.6: return "Moderate"
        case 0.6..<0.8: return "Severe"
        default: return "Critical"
        }
    }
}
