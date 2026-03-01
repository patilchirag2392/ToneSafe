//
//  HighlightedTextView.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

struct HighlightedTextView: View {
    let text: String
    let flaggedWords: [String]
    
    var body: some View {
        buildHighlightedText()
            .font(.tsBody(15))
            .lineSpacing(4)
    }
    
    private func buildHighlightedText() -> Text {
        guard !flaggedWords.isEmpty else {
            return Text(text)
                .foregroundColor(.tsText)
        }
        
        let lowercased = text.lowercased()
        var result = Text("")
        var currentIndex = text.startIndex
        
        // Find all occurrences of flagged words, sorted by position
        var highlights: [(range: Range<String.Index>, word: String)] = []
        
        for word in flaggedWords {
            let lowWord = word.lowercased()
            var searchStart = lowercased.startIndex
            
            while searchStart < lowercased.endIndex,
                  let range = lowercased.range(of: lowWord, range: searchStart..<lowercased.endIndex) {
                let originalRange = range.lowerBound..<range.upperBound
                highlights.append((range: originalRange, word: word))
                searchStart = range.upperBound
            }
        }
        
        // Sort by position
        highlights.sort { $0.range.lowerBound < $1.range.lowerBound }
        
        // Remove overlapping highlights
        var filtered: [(range: Range<String.Index>, word: String)] = []
        for highlight in highlights {
            if let last = filtered.last {
                if highlight.range.lowerBound >= last.range.upperBound {
                    filtered.append(highlight)
                }
            } else {
                filtered.append(highlight)
            }
        }
        
        // Build attributed text
        for highlight in filtered {
            if currentIndex < highlight.range.lowerBound {
                let normalText = String(text[currentIndex..<highlight.range.lowerBound])
                result = result + Text(normalText).foregroundColor(.tsText)
            }
            
            let highlightedText = String(text[highlight.range])
            result = result + Text(highlightedText)
                .foregroundColor(.tsDanger)
                .bold()
                .underline()
            
            currentIndex = highlight.range.upperBound
        }
        
        if currentIndex < text.endIndex {
            let remaining = String(text[currentIndex...])
            result = result + Text(remaining).foregroundColor(.tsText)
        }
        
        return result
    }
}
