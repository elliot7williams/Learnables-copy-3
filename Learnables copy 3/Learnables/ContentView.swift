//
//  ContentView.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    @State private var showMainMenu = true
    @State private var showSettings = false
    @State private var showInventory = false
    @State private var showLeaderboard = false
    @State private var showAchievements = false
    @State private var showCompanions = false
    @State private var selectedTab = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with weather effects - extends to edges
                backgroundView
                    .ignoresSafeArea(.all, edges: .all)
                
                // Content respects safe area
                VStack {
                    if showMainMenu {
                        mainMenuView
                    } else {
                        gameView
                    }
                }
                .padding(.top, geometry.safeAreaInsets.top)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .padding(.leading, geometry.safeAreaInsets.leading)
                .padding(.trailing, geometry.safeAreaInsets.trailing)
                .clipped()
                
                // Overlays
                challengeOverlay
                gameOverOverlay
                achievementOverlay
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Force single view on all devices
        .onAppear {
            gameManager.startGame()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(gameManager: gameManager)
        }
        .sheet(isPresented: $showInventory) {
            InventoryView(gameManager: gameManager)
        }
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView(gameManager: gameManager)
        }
        .sheet(isPresented: $showAchievements) {
            AchievementsView(gameManager: gameManager)
        }
        .sheet(isPresented: $showCompanions) {
            CompanionsView(gameManager: gameManager)
        }
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        ZStack {
            // Base background
            LinearGradient(
                colors: timeBasedColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Weather effects
            weatherEffectsView
            
            // Location-specific background
            if let backgroundImage = getLocationBackground() {
                Image(backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.3)
                    .ignoresSafeArea()
            }
        }
    }
    
    private var timeBasedColors: [Color] {
        switch gameManager.timeOfDay {
        case .dawn: return [.orange, .pink, .blue]
        case .morning: return [.blue, .cyan, .yellow]
        case .afternoon: return [.yellow, .orange, .blue]
        case .evening: return [.orange, .red, .purple]
        case .night: return [.purple, .blue, .black]
        case .midnight: return [.black, .blue, .purple]
        }
    }
    
    private var weatherEffectsView: some View {
        Group {
            switch gameManager.currentWeather {
            case .rain:
                RainEffectView()
            case .snow:
                SnowEffectView()
            case .storm:
                StormEffectView()
            case .fog:
                FogEffectView()
            case .sunny:
                SunEffectView()
            case .none:
                EmptyView()
            }
        }
    }
    
    // MARK: - Main Menu (Simplified Responsive)
    private var mainMenuView: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header section
                responsiveHeader
                
                // Player stats with responsive grid
                responsivePlayerStats
                
                // Menu buttons with responsive grid
                responsiveMenuButtons
                
                // Optional content for larger screens only
                responsiveOptionalContent
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var responsiveHeader: some View {
        VStack(spacing: 12) {
            Text("Learnables")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            
            Text("Epic English Adventure")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
    
    private var responsivePlayerStats: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            StatCard(title: "Level", value: "\(gameManager.userProgress.level)", icon: "star.fill")
            StatCard(title: "XP", value: "\(gameManager.userProgress.xp)", icon: "bolt.fill")
            StatCard(title: "Streak", value: "\(gameManager.userProgress.streak)", icon: "flame.fill")
            StatCard(title: "Lives", value: "\(gameManager.userProgress.lives)", icon: "heart.fill")
            StatCard(title: "Stories", value: "\(gameManager.userProgress.completedStories.count)", icon: "book.fill")
            StatCard(title: "Achievements", value: "\(gameManager.userProgress.achievements.count)", icon: "trophy.fill")
        }
        .padding(.horizontal, 4)
    }
    
    private func StatCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var responsiveMenuButtons: some View {
        VStack(spacing: 12) {
            // Primary button - full width
            Button(action: {
                withAnimation {
                    showMainMenu = false
                }
            }) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    Text("Start Adventure")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.green)
                .cornerRadius(12)
            }
            
            // Secondary buttons - grid layout
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                SimpleMenuButton(title: "Inventory", icon: "backpack.fill", color: .blue) {
                    showInventory = true
                }
                
                SimpleMenuButton(title: "Settings", icon: "gear", color: .gray) {
                    showSettings = true
                }
                
                SimpleMenuButton(title: "Achievements", icon: "trophy.fill", color: .yellow) {
                    showAchievements = true
                }
                
                SimpleMenuButton(title: "Leaderboard", icon: "chart.bar.fill", color: .orange) {
                    showLeaderboard = true
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func SimpleMenuButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var responsiveOptionalContent: some View {
        VStack(spacing: 12) {
            Text("Recent Achievements")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.yellow)
                Text("Level Up!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
    }
    
    
    private var playerStatsView: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let isVerySmall = availableWidth < 300
            let spacing: CGFloat = isVerySmall ? 4 : 8
            let padding: CGFloat = isVerySmall ? 8 : 12
            
            HStack(spacing: spacing) {
                statCard("Level", value: "\(gameManager.userProgress.level)", color: .blue, availableWidth: availableWidth)
                statCard("XP", value: "\(gameManager.userProgress.xp)", color: .green, availableWidth: availableWidth)
                statCard("Lives", value: "\(gameManager.userProgress.lives)", color: .red, availableWidth: availableWidth)
                statCard("Streak", value: "\(gameManager.userProgress.streak)", color: .orange, availableWidth: availableWidth)
            }
            .padding(padding)
            .background(Color.black.opacity(0.3))
            .cornerRadius(isVerySmall ? 10 : 15)
            .frame(maxWidth: availableWidth)
        }
        .frame(height: 80)
    }
    
    private func statCard(_ title: String, value: String, color: Color, availableWidth: CGFloat) -> some View {
        let isVerySmall = availableWidth < 300
        let isSmall = availableWidth < 350
        
        return VStack(spacing: 2) {
            Text(title)
                .font(.system(size: isVerySmall ? 9 : (isSmall ? 10 : 12)))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .multilineTextAlignment(.center)
            Text(value)
                .font(.system(size: isVerySmall ? 12 : (isSmall ? 14 : 16), weight: .bold))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
    
    // Legacy statCard function for compatibility
    private func statCard(_ title: String, value: String, color: Color, geometry: GeometryProxy) -> some View {
        statCard(title, value: value, color: color, availableWidth: geometry.size.width)
    }
    
    private func responsiveMenuButton(_ title: String, systemImage: String, screenWidth: CGFloat, action: @escaping () -> Void) -> some View {
        let isVerySmall = screenWidth < 350
        let isSmall = screenWidth < 400
        
        return Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.white)
                    .font(.system(size: isVerySmall ? 10 : (isSmall ? 12 : 14)))
                    .frame(width: isVerySmall ? 14 : (isSmall ? 16 : 18), height: isVerySmall ? 14 : (isSmall ? 16 : 18))
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: isVerySmall ? 10 : (isSmall ? 11 : 13)))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .truncationMode(.tail)
                    .allowsTightening(true)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, isVerySmall ? 6 : (isSmall ? 8 : 12))
            .padding(.vertical, isVerySmall ? 6 : (isSmall ? 8 : 10))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.2))
            .cornerRadius(isVerySmall ? 4 : 6)
        }
    }
    
    
    // MARK: - Responsive Components (HTML-inspired)
    private func responsiveButton(title: String, systemImage: String, screenWidth: CGFloat, isPrimary: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .foregroundColor(.white)
                    .font(.system(size: responsiveIconSize(screenWidth: screenWidth)))
                    .frame(width: 16, height: 16)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: responsiveFontSize(screenWidth: screenWidth), weight: isPrimary ? .semibold : .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, responsiveButtonPadding(screenWidth: screenWidth))
            .padding(.vertical, isPrimary ? 14 : 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isPrimary ? Color.blue.opacity(0.7) : Color.white.opacity(0.2))
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func responsiveCompactButton(_ title: String, systemImage: String, screenWidth: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .foregroundColor(.white)
                    .font(.system(size: responsiveIconSize(screenWidth: screenWidth) - 2))
                    .frame(width: 14, height: 14)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: responsiveFontSize(screenWidth: screenWidth) - 3))
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.2))
            .cornerRadius(6)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func responsivePlayerStats(screenWidth: CGFloat) -> some View {
        HStack(spacing: responsiveSpacing(screenWidth: screenWidth)) {
            responsiveStatCard("Level", value: "\(gameManager.userProgress.level)", color: .blue, screenWidth: screenWidth)
            responsiveStatCard("XP", value: "\(gameManager.userProgress.xp)", color: .green, screenWidth: screenWidth)
            responsiveStatCard("Lives", value: "\(gameManager.userProgress.lives)", color: .red, screenWidth: screenWidth)
            responsiveStatCard("Streak", value: "\(gameManager.userProgress.streak)", color: .orange, screenWidth: screenWidth)
        }
        .padding(responsiveStatsInnerPadding(screenWidth: screenWidth))
        .background(Color.black.opacity(0.3))
        .cornerRadius(responsiveCornerRadius(screenWidth: screenWidth))
        .frame(height: responsiveStatsHeight(screenWidth: screenWidth))
    }
    
    private func responsiveStatCard(_ title: String, value: String, color: Color, screenWidth: CGFloat) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: responsiveFontSize(screenWidth: screenWidth) - 2))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            
            Text(value)
                .font(.system(size: responsiveFontSize(screenWidth: screenWidth), weight: .bold))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
    
    // MARK: - Responsive Sizing Functions (CSS-like breakpoints)
    private func responsiveFontSize(screenWidth: CGFloat) -> CGFloat {
        if screenWidth < 350 {
            return 11  // XS
        } else if screenWidth < 400 {
            return 13  // SM  
        } else if screenWidth < 768 {
            return 15  // MD
        } else {
            return 17  // LG
        }
    }
    
    private func responsiveIconSize(screenWidth: CGFloat) -> CGFloat {
        if screenWidth < 350 {
            return 12
        } else if screenWidth < 400 {
            return 14
        } else {
            return 16
        }
    }
    
    private func responsiveButtonPadding(screenWidth: CGFloat) -> CGFloat {
        if screenWidth < 350 {
            return 10
        } else if screenWidth < 400 {
            return 12
        } else {
            return 16
        }
    }
    
    private func responsiveSpacing(screenWidth: CGFloat) -> CGFloat {
        if screenWidth < 350 {
            return 4
        } else if screenWidth < 400 {
            return 6
        } else {
            return 8
        }
    }
    
    private func responsiveStatsInnerPadding(screenWidth: CGFloat) -> CGFloat {
        if screenWidth < 350 {
            return 8
        } else if screenWidth < 400 {
            return 10
        } else {
            return 12
        }
    }
    
    private func responsiveCornerRadius(screenWidth: CGFloat) -> CGFloat {
        if screenWidth < 350 {
            return 8
        } else {
            return 12
        }
    }
    
    private func responsiveStatsHeight(screenWidth: CGFloat) -> CGFloat {
        if screenWidth < 350 {
            return 70
        } else if screenWidth < 400 {
            return 75
        } else {
            return 80
        }
    }
    
    // Legacy button function for compatibility
    private func menuButton(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        responsiveButton(title: title, systemImage: systemImage, screenWidth: 400, action: action)
    }
    
    private func compactMenuButton(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .frame(width: 20, height: 20)
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .fontWeight(.medium)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 6)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    private var dailyQuestPreview: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                Text("Today's Quests")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                ForEach(gameManager.dailyQuests.prefix(2)) { quest in
                    HStack {
                        Text(quest.title)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        Spacer(minLength: 5)
                        ProgressView(value: quest.progressPercentage)
                            .frame(width: 60)
                            .tint(.green)
                    }
                }
            }
            .padding(min(16, geometry.size.width * 0.04))
            .background(Color.black.opacity(0.3))
            .cornerRadius(10)
        }
        .frame(height: 100)
    }
    
    private func seasonalEventBanner(_ event: SeasonalEvent) -> some View {
        GeometryReader { geometry in
            VStack{
                Text(event.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text(event.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                Text("\(event.bonusMultiplier)x XP Bonus!")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(min(16, geometry.size.width * 0.04))
            .background(Color.purple.opacity(0.3))
            .cornerRadius(10)
        }
        .frame(height: 120)
    }
    
    // MARK: - Game View
    private var gameView: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let isSmallScreen = screenWidth < 400
            
            VStack(spacing: isSmallScreen ? 10 : 20) {
                // Top HUD
                topHUD
                
                Spacer(minLength: 0)
                
                // Story Content
                if let story = gameManager.currentStory {
                    storyView(story, geometry: geometry)
                }
                
                Spacer(minLength: 0)
                
                // Bottom Controls - Show only if enough space
                if geometry.size.height > 500 {
                    bottomControls
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
    }
    
    private var topHUD: some View {
        HStack {
            // Back button
            Button(action: { showMainMenu = true }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            
            Spacer()
            
            // Lives
            HStack {
                ForEach(0..<3, id: \.self) { index in
                    Image(systemName: "heart.fill")
                        .foregroundColor(index < gameManager.userProgress.lives ? .red : .gray)
                }
            }
            
            Spacer()
            
            // XP
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("\(gameManager.userProgress.xp)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal)
    }
    
    private func storyView(_ story: StoryElement, geometry: GeometryProxy) -> some View {
        ScrollView {
            VStack(spacing: min(20, geometry.size.height * 0.025)) {
                // Story Title
                Text(story.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(2)
                
                // Story Description
                Text(story.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .minimumScaleFactor(0.6)
                
                // Choices
                VStack(spacing: min(10, geometry.size.height * 0.015)) {
                    ForEach(story.choices) { choice in
                        choiceButton(choice, geometry: geometry)
                    }
                }
            }
            .padding(.horizontal, min(16, geometry.size.width * 0.04))
        }
    }
    
    private func choiceButton(_ choice: StoryElement.Choice, geometry: GeometryProxy) -> some View {
        Button(action: {
            gameManager.makeChoice(choice)
        }) {
            HStack {
                Text(choice.text)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.6)
                    .lineLimit(3)
                Spacer()
                if choice.challenge != nil {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.yellow)
                        .font(.system(size: 14))
                }
            }
            .padding(min(16, geometry.size.width * 0.04))
            .background(Color.blue.opacity(0.6))
            .cornerRadius(10)
        }
    }
    
    private var bottomControls: some View {
        HStack(spacing: 12) {
            Button("Inventory") {
                showInventory = true
            }
            .font(.system(size: 14))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
            
            Button("Companions") {
                showCompanions = true
            }
            .font(.system(size: 14))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    // MARK: - Overlays
    private var challengeOverlay: some View {
        Group {
            if gameManager.showingChallenge, let challenge = gameManager.currentChallenge {
                ChallengeView(challenge: challenge, gameManager: gameManager)
                    .transition(.scale)
            }
        }
    }
    
    private var gameOverOverlay: some View {
        Group {
            if gameManager.showingGameOver {
                GameOverView(gameManager: gameManager) {
                    showMainMenu = true
                }
                .transition(.opacity)
            }
        }
    }
    
    private var achievementOverlay: some View {
        Group {
            if let achievement = gameManager.showingAchievement {
                AchievementPopupView(achievement: achievement) {
                    gameManager.showingAchievement = nil
                }
                .transition(.move(edge: .top))
            }
        }
    }
    
    // MARK: - Helper Methods
    private func getLocationBackground() -> String? {
        return gameManager.currentLocation.backgroundImageName
    }
}

#Preview {
    ContentView()
}
