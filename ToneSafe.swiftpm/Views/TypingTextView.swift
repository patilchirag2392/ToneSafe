//
//  TypingTextView.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

/// Renders `fullText` word-by-word up to `visibleWordCount`.
/// Used by Empathy Mode's building phase to create a typewriter effect.
struct TypingTextView: View {
    let fullText: String
    let visibleWordCount: Int

    private var visibleText: String {
        let words = fullText.split(separator: " ", omittingEmptySubsequences: false)
        let count = min(visibleWordCount, words.count)
        return words.prefix(count).joined(separator: " ")
    }

    var body: some View {
        Text(visibleText)
    }
}
