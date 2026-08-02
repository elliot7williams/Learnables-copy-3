//
//  UserProgress.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import Foundation

class UserProgress: ObservableObject, Codable {
    @Published var currentStoryId: UUID?
    @Published var xp: Int = 0
    @Published var level: Int = 1
    @Published var lives: Int = 3
    @Published var skillLevels: [String: Int] = [
        "vocabulary": 1,
        "grammar": 1,
        "reading": 1,
        "listening": 1,
        "writing": 1
    ]
    @Published var completedStories: Set<UUID> = []
    @Published var achievements: [Achievement] = []
    @Published var streak: Int = 0
    @Published var lastPlayDate: Date?
    @Published var unlocked: Set<String> = ["starting_village"]
    
    enum CodingKeys: String, CodingKey {
        case currentStoryId, xp, level, lives, skillLevels, completedStories, achievements, streak, lastPlayDate, unlocked
    }
    
    init() {
        updateStreak()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentStoryId = try container.decodeIfPresent(UUID.self, forKey: .currentStoryId)
        xp = try container.decode(Int.self, forKey: .xp)
        level = try container.decode(Int.self, forKey: .level)
        lives = try container.decode(Int.self, forKey: .lives)
        skillLevels = try container.decode([String: Int].self, forKey: .skillLevels)
        completedStories = try container.decode(Set<UUID>.self, forKey: .completedStories)
        achievements = try container.decode([Achievement].self, forKey: .achievements)
        streak = try container.decode(Int.self, forKey: .streak)
        lastPlayDate = try container.decodeIfPresent(Date.self, forKey: .lastPlayDate)
        unlocked = try container.decodeIfPresent(Set<String>.self, forKey: .unlocked) ?? ["starting_village"]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentStoryId, forKey: .currentStoryId)
        try container.encode(xp, forKey: .xp)
        try container.encode(level, forKey: .level)
        try container.encode(lives, forKey: .lives)
        try container.encode(skillLevels, forKey: .skillLevels)
        try container.encode(completedStories, forKey: .completedStories)
        try container.encode(achievements, forKey: .achievements)
        try container.encode(streak, forKey: .streak)
        try container.encode(lastPlayDate, forKey: .lastPlayDate)
        try container.encode(unlocked, forKey: .unlocked)
    }
    
    func addXP(_ amount: Int) {
        xp += amount
        checkLevelUp()
    }
    
    func loseLife() {
        lives -= 1
    }
    
    func restoreLife() {
        if lives < 3 {
            lives += 1
        }
    }
    
    func checkLevelUp() {
        let xpForNextLevel = level * 100
        if xp >= xpForNextLevel {
            level += 1
            lives = min(lives + 1, 3) // Restore a life on level up
        }
    }
    
    func updateStreak() {
        let calendar = Calendar.current
        let today = Date()
        
        if let lastDate = lastPlayDate {
            if calendar.isDate(lastDate, inSameDayAs: today) {
                // Already played today, don't update streak
                return
            } else if calendar.isDate(lastDate, equalTo: today, toGranularity: .day) ||
                      calendar.dateInterval(of: .day, for: lastDate)?.end == calendar.dateInterval(of: .day, for: today)?.start {
                // Consecutive day
                streak += 1
            } else {
                // Streak broken
                streak = 1
            }
        } else {
            streak = 1
        }
        
        lastPlayDate = today
    }
    
    var isGameOver: Bool {
        return lives <= 0
    }
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let unlockDate: Date
    let type: AchievementType
    
    init(id: UUID = UUID(), title: String, description: String, unlockDate: Date, type: AchievementType) {
        self.id = id
        self.title = title
        self.description = description
        self.unlockDate = unlockDate
        self.type = type
    }
    
    enum AchievementType: String, CaseIterable, Codable {
        case firstStory = "first_story"
        case streakMaster = "streak_master"
        case vocabularyExpert = "vocabulary_expert"
        case grammarGuru = "grammar_guru"
        case survivor = "survivor"
        case completionist = "completionist"
    }
}
