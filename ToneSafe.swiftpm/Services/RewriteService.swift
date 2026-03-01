//
//  RewriteService.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import Foundation

/// A single rewrite suggestion
struct RewriteSuggestion: Identifiable {
    let id = UUID()
    let original: String
    let rewrite: String
    let explanation: String
    let matchedPattern: String
}

/// Service that provides healthier rewrite suggestions for harmful messages
class RewriteService {
    
    struct RewriteEntry: Decodable {
        let pattern: String
        let rewrite: String
        let explanation: String
    }
    
    private var rewriteBank: [String: [RewriteEntry]] = [:]
    
    init() {
        loadRewriteBank()
    }
    
    private func loadRewriteBank() {
        guard let url = Bundle.main.url(forResource: "RewriteBank", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("⚠️ RewriteBank.json not found in bundle")
            return
        }
        
        do {
            rewriteBank = try JSONDecoder().decode([String: [RewriteEntry]].self, from: data)
            print("✅ RewriteBank loaded with \(rewriteBank.values.flatMap { $0 }.count) entries")
        } catch {
            print("⚠️ Failed to decode RewriteBank: \(error)")
        }
    }
    
    /// Find the best rewrite suggestion for a given message and its detected category
    func suggest(for text: String, category: ToneCategory) -> RewriteSuggestion {
        let lowercased = text.lowercased()
        
        // First: try to find a pattern match in the detected category
        if let entries = rewriteBank[category.rawValue] {
            for entry in entries {
                if lowercased.contains(entry.pattern.lowercased()) {
                    return RewriteSuggestion(
                        original: text,
                        rewrite: entry.rewrite,
                        explanation: entry.explanation,
                        matchedPattern: entry.pattern
                    )
                }
            }
            // No exact match — return the first entry as a category-level suggestion
            if let first = entries.first {
                return RewriteSuggestion(
                    original: text,
                    rewrite: first.rewrite,
                    explanation: first.explanation,
                    matchedPattern: "general \(category.displayName) pattern"
                )
            }
        }
        
        // Fallback
        let fallback = rewriteBank["fallback"]?.first
        return RewriteSuggestion(
            original: text,
            rewrite: fallback?.rewrite ?? "I'd like to express how I feel in a more constructive way.",
            explanation: fallback?.explanation ?? "Taking a moment to rephrase can make a big difference.",
            matchedPattern: "general"
        )
    }
}
