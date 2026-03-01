//
//  DesignSystem.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

// MARK: - ToneSafe Design System
// Warm, human, empathetic. Not corporate. Not generic.

extension Color {
    // Primary palette — warm and approachable
    static let tsBackground = Color(red: 0.98, green: 0.97, blue: 0.95)       // Warm cream
    static let tsSurface = Color(red: 0.95, green: 0.93, blue: 0.90)          // Soft warm gray
    static let tsSurfaceElevated = Color.white
    
    // Text
    static let tsText = Color(red: 0.12, green: 0.10, blue: 0.09)             // Near-black, warm
    static let tsTextSecondary = Color(red: 0.45, green: 0.42, blue: 0.38)    // Warm gray
    static let tsTextTertiary = Color(red: 0.65, green: 0.62, blue: 0.58)     // Light warm gray
    
    // Accent — a single bold color that means "action"
    static let tsAccent = Color(red: 0.20, green: 0.25, blue: 0.95)           // Deep electric blue
    static let tsAccentSoft = Color(red: 0.20, green: 0.25, blue: 0.95).opacity(0.08)
    
    // Semantic colors — muted, not screaming
    static let tsHealthy = Color(red: 0.18, green: 0.70, blue: 0.48)          // Sage green
    static let tsCaution = Color(red: 0.85, green: 0.65, blue: 0.20)          // Amber
    static let tsWarning = Color(red: 0.90, green: 0.45, blue: 0.25)          // Burnt orange
    static let tsDanger = Color(red: 0.85, green: 0.22, blue: 0.20)           // Deep red
    static let tsSevere = Color(red: 0.50, green: 0.15, blue: 0.55)           // Deep plum
    
    // Empathy Mode gradients
    static let empathyStart = Color(red: 0.08, green: 0.06, blue: 0.14)
    static let empathyMid = Color(red: 0.18, green: 0.05, blue: 0.10)
    static let empathyEnd = Color(red: 0.04, green: 0.03, blue: 0.08)
}

// MARK: - ShapeStyle Convenience

extension ShapeStyle where Self == Color {
    static var tsBackground: Color { .tsBackground }
    static var tsSurface: Color { .tsSurface }
    static var tsSurfaceElevated: Color { .tsSurfaceElevated }
    static var tsText: Color { .tsText }
    static var tsTextSecondary: Color { .tsTextSecondary }
    static var tsTextTertiary: Color { .tsTextTertiary }
    static var tsAccent: Color { .tsAccent }
    static var tsAccentSoft: Color { .tsAccentSoft }
    static var tsHealthy: Color { .tsHealthy }
    static var tsCaution: Color { .tsCaution }
    static var tsWarning: Color { .tsWarning }
    static var tsDanger: Color { .tsDanger }
    static var tsSevere: Color { .tsSevere }
}

// MARK: - Typography

extension Font {
    // Display — for big emotional moments
    static func tsDisplay(_ size: CGFloat = 34) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }
    
    // Title
    static func tsTitle(_ size: CGFloat = 24) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
    
    // Body — readable and warm
    static func tsBody(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    
    // Caption
    static func tsCaption(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
    
    // Mono — for data/numbers
    static func tsMono(_ size: CGFloat = 14) -> Font {
        .system(size: size, weight: .semibold, design: .monospaced)
    }
}

// MARK: - Reusable Modifiers

struct TSCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(Color.tsSurfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
    }
}

struct TSSecondaryCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color.tsSurface.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

extension View {
    func tsCard() -> some View { modifier(TSCardStyle()) }
    func tsSecondaryCard() -> some View { modifier(TSSecondaryCardStyle()) }
}

// MARK: - Category Colors

extension ToneCategory {
    var themeColor: Color {
        switch self {
        case .healthy: return .tsHealthy
        case .passiveAggression: return .tsCaution
        case .manipulation: return .tsWarning
        case .bullying: return .tsDanger
        case .hateSpeed: return .tsSevere
        }
    }
}
