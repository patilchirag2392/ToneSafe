//
//  HomeView.swift
//  ToneSafe
//
//  Created by Chirag Patil on 2/14/26.
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var stats: [StatItem] = []
    @State private var mission: String = ""
    @State private var animateIn = false
    @State private var breathe = false
    
    struct StatItem: Identifiable, Decodable {
        let id = UUID()
        let value: String
        let description: String
        let source: String
        enum CodingKeys: String, CodingKey { case value, description, source }
    }
    
    struct StatsData: Decodable {
        let stats: [StatItem]
        let mission: String
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Hero
                    heroSection
                    
                    // Analyze CTA
                    analyzeCTA
                    
                    // Mission
                    if !mission.isEmpty {
                        missionCard
                    }
                    
                    // Stats
                    if !stats.isEmpty {
                        statsSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color.tsBackground)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadStats()
            withAnimation(.easeOut(duration: 1.0)) { animateIn = true }
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) { breathe = true }
        }
    }
    
    // MARK: - Hero
    
    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                // Breathing glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.tsAccent.opacity(0.12), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: breathe ? 80 : 60
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: "shield.checkered")
                    .font(.system(size: 52, weight: .light))
                    .foregroundStyle(Color.tsAccent)
            }
            
            VStack(spacing: 6) {
                Text("ToneSafe")
                    .font(.tsDisplay(34))
                    .foregroundStyle(.tsText)
                
                Text("Think before you send.")
                    .font(.tsBody(16))
                    .foregroundStyle(.tsTextSecondary)
                    .italic()
            }
        }
        .padding(.top, 24)
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 15)
    }
    
    // MARK: - Analyze CTA
    
    private var analyzeCTA: some View {
        Button {
            selectedTab = 1
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "text.magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Analyze a Message")
                        .font(.tsBody(16))
                        .fontWeight(.semibold)
                    Text("Check any text for harmful patterns")
                        .font(.tsCaption(13))
                        .opacity(0.8)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(20)
            .background(
                LinearGradient(
                    colors: [Color.tsAccent, Color.tsAccent.opacity(0.85)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.tsAccent.opacity(0.2), radius: 16, x: 0, y: 8)
        }
        .opacity(animateIn ? 1 : 0)
        .offset(y: animateIn ? 0 : 10)
    }
    
    // MARK: - Mission
    
    private var missionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Rectangle()
                    .fill(Color.tsAccent)
                    .frame(width: 3, height: 20)
                    .clipShape(Capsule())
                
                Text("Our Mission")
                    .font(.tsCaption(13))
                    .fontWeight(.bold)
                    .foregroundStyle(.tsAccent)
                    .textCase(.uppercase)
                    .tracking(1.2)
            }
            
            Text(mission)
                .font(.tsBody(15))
                .foregroundStyle(.tsTextSecondary)
                .lineSpacing(6)
        }
        .tsCard()
        .opacity(animateIn ? 1 : 0)
    }
    
    // MARK: - Stats
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("The Reality")
                .font(.tsTitle(20))
                .foregroundStyle(.tsText)
            
            ForEach(Array(stats.enumerated()), id: \.element.id) { index, stat in
                HStack(alignment: .top, spacing: 16) {
                    Text(stat.value)
                        .font(.tsMono(22))
                        .foregroundStyle(.tsAccent)
                        .frame(width: 64, alignment: .trailing)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stat.description)
                            .font(.tsBody(14))
                            .foregroundStyle(.tsText)
                            .lineSpacing(3)
                        
                        Text(stat.source)
                            .font(.tsCaption(11))
                            .foregroundStyle(.tsTextTertiary)
                    }
                }
                .padding(.vertical, 12)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 10)
                .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.08 + 0.3), value: animateIn)
                
                if index < stats.count - 1 {
                    Divider().foregroundStyle(.tsSurface)
                }
            }
        }
        .tsCard()
    }
    
    private func loadStats() {
        guard let url = Bundle.main.url(forResource: "ImpactStats", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(StatsData.self, from: data) else { return }
        stats = decoded.stats
        mission = decoded.mission
    }
}
