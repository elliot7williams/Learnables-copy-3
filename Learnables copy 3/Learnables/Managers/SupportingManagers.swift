//
//  SupportingManagers.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import Foundation
import SwiftUI
import AVFoundation
import CoreHaptics

// MARK: - Sound Manager
class SoundManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private var backgroundPlayer: AVAudioPlayer?
    private var soundEffectsEnabled = true
    private var musicEnabled = true
    private var volume: Float = 0.7
    
    enum SoundEffect: String, CaseIterable {
        case success = "success_sound"
        case failure = "failure_sound"
        case levelUp = "level_up_sound"
        case gameOver = "game_over_sound"
        case achievement = "achievement_sound"
        case buttonClick = "button_click"
        case pageFlip = "page_flip"
        case itemCollect = "item_collect"
        case companion = "companion_sound"
        case magic = "magic_sound"
    }
    
    enum BackgroundMusic: String, CaseIterable {
        case mainTheme = "main_theme"
        case village = "village_theme"
        case forest = "forest_theme"
        case library = "library_theme"
        case cave = "cave_theme"
        case temple = "temple_theme"
        case dragon = "dragon_theme"
        case victory = "victory_theme"
        case gameOver = "game_over_theme"
    }
    
    func playSound(_ effect: SoundEffect) {
        guard soundEffectsEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") else {
            print("Could not find sound file: \(effect.rawValue)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    func playBackgroundMusic(_ music: BackgroundMusic, loop: Bool = true) {
        guard musicEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: music.rawValue, withExtension: "mp3") else {
            print("Could not find music file: \(music.rawValue)")
            return
        }
        
        do {
            backgroundPlayer?.stop()
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.volume = volume * 0.5 // Background music at lower volume
            backgroundPlayer?.numberOfLoops = loop ? -1 : 0
            backgroundPlayer?.play()
        } catch {
            print("Error playing background music: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }
    
    func setSoundEffectsEnabled(_ enabled: Bool) {
        soundEffectsEnabled = enabled
    }
    
    func setMusicEnabled(_ enabled: Bool) {
        musicEnabled = enabled
        if !enabled {
            stopBackgroundMusic()
        }
    }
    
    func setVolume(_ newVolume: Float) {
        volume = newVolume
        audioPlayer?.volume = volume
        backgroundPlayer?.volume = volume * 0.5
    }
    
    // Convenience methods
    func playSuccessSound() { playSound(.success) }
    func playFailureSound() { playSound(.failure) }
    func playLevelUpSound() { playSound(.levelUp) }
    func playGameOverSound() { playSound(.gameOver) }
    func playAchievementSound() { playSound(.achievement) }
    func playButtonClick() { playSound(.buttonClick) }
}

// MARK: - Haptic Manager
class HapticManager {
    static let shared = HapticManager()
    private var engine: CHHapticEngine?
    
    private init() {
        setupHaptics()
    }
    
    private func setupHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error starting haptic engine: \(error)")
        }
    }
    
    func playSuccess() {
        guard engine != nil else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        
        let events = [
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0),
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.1),
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.2)
        ]
        
        playHapticPattern(events)
    }
    
    func playFailure() {
        guard engine != nil else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        playHapticPattern([event])
    }
    
    func playLevelUp() {
        guard engine != nil else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
        
        let events = (0..<5).map { i in
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: Double(i) * 0.1)
        }
        
        playHapticPattern(events)
    }
    
    private func playHapticPattern(_ events: [CHHapticEvent]) {
        guard let engine = engine else { return }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Error playing haptic pattern: \(error)")
        }
    }
}

// MARK: - Storage Manager
class StorageManager {
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    enum Keys: String, CaseIterable {
        case userProgress = "user_progress"
        case inventory = "inventory"
        case companions = "companions"
        case settings = "settings"
        case achievements = "achievements"
        case statistics = "statistics"
    }
    
    func saveUserProgress(_ progress: UserProgress) {
        do {
            let data = try encoder.encode(progress)
            userDefaults.set(data, forKey: Keys.userProgress.rawValue)
        } catch {
            print("Error saving user progress: \(error)")
        }
    }
    
    func loadUserProgress() -> UserProgress? {
        guard let data = userDefaults.data(forKey: Keys.userProgress.rawValue) else { return nil }
        
        do {
            return try decoder.decode(UserProgress.self, from: data)
        } catch {
            print("Error loading user progress: \(error)")
            return nil
        }
    }
    
    func saveInventory(_ inventory: [InventoryItem]) {
        do {
            let data = try encoder.encode(inventory)
            userDefaults.set(data, forKey: Keys.inventory.rawValue)
        } catch {
            print("Error saving inventory: \(error)")
        }
    }
    
    func loadInventory() -> [InventoryItem]? {
        guard let data = userDefaults.data(forKey: Keys.inventory.rawValue) else { return nil }
        
        do {
            return try decoder.decode([InventoryItem].self, from: data)
        } catch {
            print("Error loading inventory: \(error)")
            return nil
        }
    }
    
    func saveCompanions(_ companions: [Companion]) {
        do {
            let data = try encoder.encode(companions)
            userDefaults.set(data, forKey: Keys.companions.rawValue)
        } catch {
            print("Error saving companions: \(error)")
        }
    }
    
    func loadCompanions() -> [Companion]? {
        guard let data = userDefaults.data(forKey: Keys.companions.rawValue) else { return nil }
        
        do {
            return try decoder.decode([Companion].self, from: data)
        } catch {
            print("Error loading companions: \(error)")
            return nil
        }
    }
    
    func clearAllData() {
        Keys.allCases.forEach { key in
            userDefaults.removeObject(forKey: key.rawValue)
        }
    }
}

// MARK: - Achievement Manager
class AchievementManager: ObservableObject {
    @Published var unlockedAchievements: [Achievement] = []
    
    func checkAchievements(userProgress: UserProgress, challenge: StoryElement.Challenge) {
        checkFirstStoryAchievement(userProgress)
        checkStreakAchievements(userProgress)
        checkSkillAchievements(userProgress, challenge)
        checkLevelAchievements(userProgress)
        checkSurvivalAchievements(userProgress)
        checkCompletionistAchievements(userProgress)
    }
    
    private func checkFirstStoryAchievement(_ progress: UserProgress) {
        guard !hasAchievement(.firstStory) && progress.completedStories.count >= 1 else { return }
        unlockAchievement(.firstStory, title: "First Steps", description: "Complete your first story")
    }
    
    private func checkStreakAchievements(_ progress: UserProgress) {
        guard !hasAchievement(.streakMaster) && progress.streak >= 7 else { return }
        unlockAchievement(.streakMaster, title: "Streak Master", description: "Maintain a 7-day learning streak")
    }
    
    private func checkSkillAchievements(_ progress: UserProgress, _ challenge: StoryElement.Challenge) {
        let skillLevel = progress.skillLevels[challenge.type.rawValue] ?? 1
        
        switch challenge.type {
        case .vocabulary:
            if !hasAchievement(.vocabularyExpert) && skillLevel >= 10 {
                unlockAchievement(.vocabularyExpert, title: "Word Wizard", description: "Reach level 10 in vocabulary")
            }
        case .grammar:
            if !hasAchievement(.grammarGuru) && skillLevel >= 10 {
                unlockAchievement(.grammarGuru, title: "Grammar Guru", description: "Reach level 10 in grammar")
            }
        default:
            break
        }
    }
    
    private func checkLevelAchievements(_ progress: UserProgress) {
        // Add level-based achievements
    }
    
    private func checkSurvivalAchievements(_ progress: UserProgress) {
        guard !hasAchievement(.survivor) && progress.lives == 1 else { return }
        unlockAchievement(.survivor, title: "Survivor", description: "Win with only 1 life remaining")
    }
    
    private func checkCompletionistAchievements(_ progress: UserProgress) {
        guard !hasAchievement(.completionist) && progress.completedStories.count >= 50 else { return }
        unlockAchievement(.completionist, title: "Story Master", description: "Complete 50 stories")
    }
    
    private func hasAchievement(_ type: Achievement.AchievementType) -> Bool {
        return unlockedAchievements.contains { $0.type == type }
    }
    
    private func unlockAchievement(_ type: Achievement.AchievementType, title: String, description: String) {
        let achievement = Achievement(title: title, description: description, unlockDate: Date(), type: type)
        unlockedAchievements.append(achievement)
        
        // Trigger achievement notification
        NotificationCenter.default.post(name: .achievementUnlocked, object: achievement)
    }
}

// MARK: - Analytics Manager
class AnalyticsManager {
    func trackEvent(_ eventName: String, parameters: [String: Any] = [:]) {
        // In a real app, this would send data to analytics services like Firebase Analytics
        print("Analytics Event: \(eventName), Parameters: \(parameters)")
    }
    
    func trackUserProperty(_ property: String, value: String) {
        print("User Property: \(property) = \(value)")
    }
    
    func trackScreenView(_ screenName: String) {
        print("Screen View: \(screenName)")
    }
}

// MARK: - Network Manager
class NetworkManager: ObservableObject {
    func fetchLeaderboard(completion: @escaping ([LeaderboardEntry]) -> Void) {
        // Mock leaderboard data - in real app, this would fetch from server
        let mockEntries = [
            LeaderboardEntry(playerName: "WordMaster", score: 12500, level: 25, rank: 1, country: "US", avatar: "avatar1", achievements: [.vocabularyExpert, .streakMaster], lastActive: Date()),
            LeaderboardEntry(playerName: "GrammarGuru", score: 11200, level: 22, rank: 2, country: "UK", avatar: "avatar2", achievements: [.grammarGuru], lastActive: Date()),
            LeaderboardEntry(playerName: "StorySeeker", score: 10800, level: 21, rank: 3, country: "CA", avatar: "avatar3", achievements: [.completionist], lastActive: Date())
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(mockEntries)
        }
    }
    
    func submitScore(_ score: Int, completion: @escaping (Bool) -> Void) {
        // Mock score submission
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(true)
        }
    }
    
    func fetchDailyQuests(completion: @escaping ([DailyQuest]) -> Void) {
        // Mock daily quests
        let mockQuests = [
            DailyQuest(title: "Story Explorer", description: "Complete 3 stories", type: .completeStories, target: 3, progress: 0, reward: DailyQuest.QuestReward(xp: 100, items: [], currency: 50, unlocks: []), expirationDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(mockQuests)
        }
    }
}

// MARK: - Story Data Manager
class StoryDataManager {
    static let shared = StoryDataManager()
    private var stories: [StoryElement] = []
    
    private init() {
        loadStories()
    }
    
    func getStartingStory() -> StoryElement {
        return stories.first ?? createDefaultStory()
    }
    
    func getStoryById(_ id: UUID) -> StoryElement? {
        return stories.first { $0.id == id }
    }
    
    func getAllStories() -> [StoryElement] {
        return stories
    }
    
    private func loadStories() {
        // Create comprehensive story data
        stories = createComprehensiveStorySet()
    }
    
    private func createDefaultStory() -> StoryElement {
        let challenge = StoryElement.Challenge(
            type: .vocabulary,
            question: "What does 'serendipity' mean?",
            options: ["A planned discovery", "A pleasant surprise", "A difficult situation", "A long journey"],
            correctAnswerIndex: 1,
            difficulty: .easy
        )
        
        let choice = StoryElement.Choice(
            text: "Accept the challenge",
            nextStoryId: nil,
            challenge: challenge,
            consequence: nil
        )
        
        return StoryElement(
            title: "The Beginning",
            description: "Welcome to your English learning adventure! You find yourself in a mystical village where words have power.",
            choices: [choice],
            requiredSkillLevel: 1,
            xpReward: 50
        )
    }
    
    private func createComprehensiveStorySet() -> [StoryElement] {
        var stories = [createDefaultStory()]
        
        // Generate 1000+ diverse learning stories
        stories.append(contentsOf: generateVocabularyStories())
        stories.append(contentsOf: generateGrammarStories())
        stories.append(contentsOf: generateReadingComprehensionStories())
        stories.append(contentsOf: generateListeningStories())
        stories.append(contentsOf: generateWritingStories())
        stories.append(contentsOf: generateAdvancedLiteratureStories())
        stories.append(contentsOf: generateBusinessEnglishStories())
        stories.append(contentsOf: generateConversationalStories())
        stories.append(contentsOf: generateIdiomStories())
        stories.append(contentsOf: generatePronunciationStories())
        
        return stories
    }
    
    private func createAdvancedStories() -> [StoryElement] {
        // Create additional stories with increasing complexity
        return []
    }
}

// MARK: - Extensions and Helpers
extension Notification.Name {
    static let achievementUnlocked = Notification.Name("achievementUnlocked")
    static let levelUp = Notification.Name("levelUp")
    static let lifeRestored = Notification.Name("lifeRestored")
}

