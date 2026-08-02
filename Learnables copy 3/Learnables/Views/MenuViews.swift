//
//  MenuViews.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import SwiftUI

// MARK: - Inventory View
struct InventoryView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: InventoryItem.ItemType = .consumable
    
    var body: some View {
        NavigationView {
            VStack {
                // Category Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(InventoryItem.ItemType.allCases, id: \.self) { category in
                            categoryTab(category)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Items Grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                        ForEach(filteredItems) { item in
                            itemCard(item)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Inventory")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var filteredItems: [InventoryItem] {
        gameManager.inventory.filter { $0.type == selectedCategory }
    }
    
    private func categoryTab(_ category: InventoryItem.ItemType) -> some View {
        Button(action: {
            selectedCategory = category
        }) {
            Text(category.rawValue.capitalized)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(20)
        }
    }
    
    private func itemCard(_ item: InventoryItem) -> some View {
        VStack(spacing: 8) {
            // Item Icon
            Image(systemName: getItemIcon(for: item.type))
                .font(.title)
                .foregroundColor(item.rarity.color)
            
            // Item Name
            Text(item.name)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            // Rarity Border
            RoundedRectangle(cornerRadius: 8)
                .stroke(item.rarity.color, lineWidth: 2)
                .frame(height: 0)
        }
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(item.rarity.color, lineWidth: 1)
        )
    }
    
    private func getItemIcon(for type: InventoryItem.ItemType) -> String {
        switch type {
        case .weapon: return "sword.fill"
        case .armor: return "shield.fill"
        case .consumable: return "pills.fill"
        case .book: return "book.fill"
        case .artifact: return "star.fill"
        case .currency: return "dollarsign.circle.fill"
        case .key: return "key.fill"
        case .spell: return "sparkles"
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Audio") {
                    HStack {
                        Text("Sound Effects")
                        Spacer()
                        Toggle("", isOn: $gameManager.audioEnabled)
                    }
                    
                    HStack {
                        Text("Haptic Feedback")
                        Spacer()
                        Toggle("", isOn: $gameManager.hapticEnabled)
                    }
                }
                
                Section("Appearance") {
                    HStack {
                        Text("Dark Mode")
                        Spacer()
                        Toggle("", isOn: $gameManager.darkMode)
                    }
                }
                
                Section("Difficulty") {
                    Picker("Difficulty Mode", selection: $gameManager.difficultyMode) {
                        ForEach(GameManager.DifficultyMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue.capitalized).tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section("Account") {
                    Button("Reset Progress") {
                        gameManager.resetGame()
                    }
                    .foregroundColor(.red)
                    
                    Button("Export Save Data") {
                        // Export functionality
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Privacy Policy") {
                        // Open privacy policy
                    }
                    
                    Button("Terms of Service") {
                        // Open terms
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Achievements View
struct AchievementsView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(getAllAchievements(), id: \.type) { achievement in
                        achievementCard(achievement)
                    }
                }
                .padding()
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func getAllAchievements() -> [Achievement] {
        let unlockedTypes = Set(gameManager.userProgress.achievements.map { $0.type })
        var allAchievements = gameManager.userProgress.achievements
        
        // Add locked achievements
        for type in Achievement.AchievementType.allCases {
            if !unlockedTypes.contains(type) {
                allAchievements.append(Achievement(
                    title: getAchievementTitle(for: type),
                    description: getAchievementDescription(for: type),
                    unlockDate: Date(),
                    type: type
                ))
            }
        }
        
        return allAchievements.sorted { $0.type.rawValue < $1.type.rawValue }
    }
    
    private func achievementCard(_ achievement: Achievement) -> some View {
        let isUnlocked = gameManager.userProgress.achievements.contains { $0.type == achievement.type }
        
        return HStack(spacing: 15) {
            // Achievement Icon
            Image(systemName: getAchievementIcon(for: achievement.type))
                .font(.title)
                .foregroundColor(isUnlocked ? .yellow : .gray)
                .frame(width: 50)
            
            // Achievement Details
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(isUnlocked ? .primary : .secondary)
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if isUnlocked {
                    Text("Unlocked: \\(achievement.unlockDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isUnlocked ? Color.yellow : Color.gray, lineWidth: 1)
        )
    }
    
    private func getAchievementTitle(for type: Achievement.AchievementType) -> String {
        switch type {
        case .firstStory: return "First Steps"
        case .streakMaster: return "Streak Master"
        case .vocabularyExpert: return "Word Wizard"
        case .grammarGuru: return "Grammar Guru"
        case .survivor: return "Survivor"
        case .completionist: return "Story Master"
        }
    }
    
    private func getAchievementDescription(for type: Achievement.AchievementType) -> String {
        switch type {
        case .firstStory: return "Complete your first story"
        case .streakMaster: return "Maintain a 7-day learning streak"
        case .vocabularyExpert: return "Reach level 10 in vocabulary"
        case .grammarGuru: return "Reach level 10 in grammar"
        case .survivor: return "Win with only 1 life remaining"
        case .completionist: return "Complete 50 stories"
        }
    }
    
    private func getAchievementIcon(for type: Achievement.AchievementType) -> String {
        switch type {
        case .firstStory: return "flag.fill"
        case .streakMaster: return "flame.fill"
        case .vocabularyExpert: return "textbook.fill"
        case .grammarGuru: return "pencil.and.outline"
        case .survivor: return "heart.fill"
        case .completionist: return "crown.fill"
        }
    }
}

// MARK: - Companions View
struct CompanionsView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(gameManager.companions) { companion in
                        companionCard(companion)
                    }
                    
                    if gameManager.companions.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "person.2.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No Companions Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Text("Complete stories and level up to unlock companions who will help you on your journey!")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Companions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func companionCard(_ companion: Companion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Companion Avatar
                Image(systemName: getCompanionIcon(for: companion.type))
                    .font(.title)
                    .foregroundColor(.blue)
                    .frame(width: 50, height: 50)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(25)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(companion.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(companion.type.rawValue.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                VStack {
                    Text("Level \\(companion.level)")
                        .font(.caption)
                        .fontWeight(.bold)
                    
                    Text("\\(companion.xp) XP")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(companion.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            Text(companion.backstory)
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
            
            // Abilities
            VStack(alignment: .leading, spacing: 8) {
                Text("Abilities:")
                    .font(.caption)
                    .fontWeight(.bold)
                
                ForEach(companion.abilities, id: \.name) { ability in
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                        
                        Text(ability.name)
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\\(Int(ability.cooldown))s")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func getCompanionIcon(for type: Companion.CompanionType) -> String {
        switch type {
        case .scholar: return "graduationcap.fill"
        case .warrior: return "shield.fill"
        case .mage: return "wand.and.stars"
        case .bard: return "music.note"
        case .merchant: return "bag.fill"
        case .guide: return "map.fill"
        case .animal: return "pawprint.fill"
        case .spirit: return "sparkles"
        }
    }
}

// MARK: - Leaderboard View
struct LeaderboardView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPeriod: LeaderboardPeriod = .allTime
    
    enum LeaderboardPeriod: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case allTime = "All Time"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Period Selector
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(LeaderboardPeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Leaderboard List
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(gameManager.leaderboard) { entry in
                            leaderboardRow(entry)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func leaderboardRow(_ entry: LeaderboardEntry) -> some View {
        HStack(spacing: 15) {
            // Rank
            Text(entry.displayRank)
                .font(.headline)
                .fontWeight(.bold)
                .frame(width: 40)
            
            // Player Avatar
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(entry.playerName.prefix(1)))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                )
            
            // Player Info
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.playerName)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    Text("Level \\(entry.level)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(entry.country)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Score
            VStack(alignment: .trailing) {
                Text("\\(entry.score)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(entry.rank <= 3 ? Color.yellow.opacity(0.1) : Color.clear)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(entry.rank <= 3 ? Color.yellow : Color.clear, lineWidth: 1)
        )
    }
}
