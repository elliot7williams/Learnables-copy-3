//
//  GameManager.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import Foundation
import SwiftUI
import Combine

class GameManager: ObservableObject {
    @Published var userProgress = UserProgress()
    @Published var currentStory: StoryElement?
    @Published var allStories: [StoryElement] = []
    @Published var currentChallenge: StoryElement.Challenge?
    @Published var showingChallenge = false
    @Published var showingGameOver = false
    @Published var showingVictory = false
    @Published var showingAchievement: Achievement?
    @Published var audioEnabled = true
    @Published var hapticEnabled = true
    @Published var darkMode = false
    @Published var difficultyMode: DifficultyMode = .normal
    @Published var currentWeather: WeatherEffect = .none
    @Published var timeOfDay: TimeOfDay = .morning
    @Published var inventory: [InventoryItem] = []
    @Published var companions: [Companion] = []
    @Published var currentLocation: GameLocation = .startingVillage
    @Published var unlocked: Set<String> = ["starting_village"]
    @Published var leaderboard: [LeaderboardEntry] = []
    @Published var dailyQuests: [DailyQuest] = []
    @Published var weeklyChallenge: WeeklyChallenge?
    @Published var seasonalEvent: SeasonalEvent?
    @Published var notifications: [GameNotification] = []
    @Published var tutorialProgress: TutorialProgress = TutorialProgress()
    
    private var cancellables = Set<AnyCancellable>()
    private let storageManager = StorageManager()
    private let achievementManager = AchievementManager()
    private let soundManager = SoundManager()
    private let analyticsManager = AnalyticsManager()
    private let networkManager = NetworkManager()
    
    enum DifficultyMode: String, CaseIterable {
        case easy = "easy"
        case normal = "normal"
        case hard = "hard"
        case nightmare = "nightmare"
    }
    
    enum WeatherEffect: String, CaseIterable {
        case none = "none"
        case rain = "rain"
        case snow = "snow"
        case storm = "storm"
        case fog = "fog"
        case sunny = "sunny"
    }
    
    enum TimeOfDay: String, CaseIterable {
        case dawn = "dawn"
        case morning = "morning"
        case afternoon = "afternoon"
        case evening = "evening"
        case night = "night"
        case midnight = "midnight"
    }
    
    init() {
        loadGameData()
        setupDailyQuests()
        setupWeeklyChallenge()
        checkSeasonalEvents()
        startTimeOfDayTimer()
        loadLeaderboard()
    }
    
    // MARK: - Game Flow
    func startGame() {
        // Ensure stories are loaded
        if allStories.isEmpty {
            allStories = StoryDataManager.shared.getAllStories()
        }
        
        if userProgress.currentStoryId == nil {
            currentStory = getStartingStory()
            userProgress.currentStoryId = currentStory?.id
        } else {
            if let storyId = userProgress.currentStoryId {
                currentStory = getStoryById(storyId)
            }
            
            // If we can't find the story, start with the default
            if currentStory == nil {
                currentStory = getStartingStory()
                userProgress.currentStoryId = currentStory?.id
            }
        }
        
        userProgress.updateStreak()
        analyticsManager.trackEvent("game_started")
        
        // Debug output
        print("Game started with \(allStories.count) stories loaded")
        print("Current story: \(currentStory?.title ?? "None")")
    }
    
    func makeChoice(_ choice: StoryElement.Choice) {
        analyticsManager.trackEvent("choice_made", parameters: ["choice": choice.text])
        
        if let challenge = choice.challenge {
            currentChallenge = challenge
            showingChallenge = true
        } else {
            processChoice(choice)
        }
    }
    
    func processChoice(_ choice: StoryElement.Choice) {
        // Handle consequences
        if let consequence = choice.consequence {
            handleConsequence(consequence)
        }
        
        // Move to next story
        if let nextStoryId = choice.nextStoryId {
            moveToStory(nextStoryId)
        }
        
        saveGameData()
    }
    
    func answerChallenge(selectedIndex: Int) {
        guard let challenge = currentChallenge else { return }
        
        let isCorrect = selectedIndex == challenge.correctAnswerIndex
        analyticsManager.trackEvent("challenge_answered", parameters: [
            "correct": isCorrect,
            "type": challenge.type.rawValue,
            "difficulty": challenge.difficulty.rawValue
        ])
        
        if isCorrect {
            handleCorrectAnswer(challenge)
        } else {
            handleIncorrectAnswer(challenge)
        }
        
        currentChallenge = nil
        showingChallenge = false
        saveGameData()
    }
    
    private func handleCorrectAnswer(_ challenge: StoryElement.Challenge) {
        let baseXP = getDifficultyMultiplier() * getXPForChallenge(challenge)
        userProgress.addXP(baseXP)
        
        // Update skill level
        let skillType = challenge.type.rawValue
        userProgress.skillLevels[skillType, default: 1] += 1
        
        // Add inventory rewards
        addRandomReward()
        
        // Check for achievements
        achievementManager.checkAchievements(userProgress: userProgress, challenge: challenge)
        
        soundManager.playSuccessSound()
        
        if hapticEnabled {
            HapticManager.shared.playSuccess()
        }
    }
    
    private func handleIncorrectAnswer(_ challenge: StoryElement.Challenge) {
        userProgress.loseLife()
        
        if userProgress.isGameOver {
            showingGameOver = true
            analyticsManager.trackEvent("game_over")
            soundManager.playGameOverSound()
        } else {
            soundManager.playFailureSound()
        }
        
        if hapticEnabled {
            HapticManager.shared.playFailure()
        }
    }
    
    // MARK: - Story Management
    private func getStartingStory() -> StoryElement {
        return StoryDataManager.shared.getStartingStory()
    }
    
    private func getStoryById(_ id: UUID) -> StoryElement? {
        return StoryDataManager.shared.getStoryById(id)
    }
    
    private func moveToStory(_ id: UUID) {
        if let story = getStoryById(id) {
            currentStory = story
            userProgress.currentStoryId = id
            userProgress.completedStories.insert(id)
            
            // Check if this unlocks new locations
            checkLocationUnlocks(story)
        }
    }
    
    // MARK: - Advanced Features
    private func setupDailyQuests() {
        dailyQuests = DailyQuestGenerator.generateQuests(for: Date(), userLevel: userProgress.level)
    }
    
    private func setupWeeklyChallenge() {
        weeklyChallenge = WeeklyChallengeGenerator.generateChallenge(for: Date(), userLevel: userProgress.level)
    }
    
    private func checkSeasonalEvents() {
        seasonalEvent = SeasonalEventManager.getCurrentEvent()
    }
    
    private func startTimeOfDayTimer() {
        Timer.publish(every: 300, on: .main, in: .common) // Every 5 minutes
            .autoconnect()
            .sink { _ in
                self.updateTimeOfDay()
            }
            .store(in: &cancellables)
    }
    
    private func updateTimeOfDay() {
        let hour = Calendar.current.component(.hour, from: Date())
        timeOfDay = TimeOfDay.fromHour(hour)
        
        // Random weather changes
        if Int.random(in: 1...10) == 1 {
            currentWeather = WeatherEffect.allCases.randomElement() ?? .none
        }
    }
    
    private func checkLocationUnlocks(_ story: StoryElement) {
        // Logic to unlock new locations based on story progression
        let newLocations = LocationManager.getUnlockedLocations(for: story, userProgress: userProgress)
        unlocked.formUnion(newLocations)
    }
    
    private func addRandomReward() {
        let possibleRewards = InventoryManager.getAvailableRewards(userLevel: userProgress.level)
        if let reward = possibleRewards.randomElement() {
            inventory.append(reward)
        }
    }
    
    private func handleConsequence(_ consequence: StoryElement.Consequence) {
        switch consequence.type {
        case .death:
            userProgress.loseLife()
            if userProgress.isGameOver {
                showingGameOver = true
                analyticsManager.trackEvent("game_over_consequence")
                soundManager.playGameOverSound()
            } else {
                soundManager.playFailureSound()
            }
            
        case .injury:
            userProgress.loseLife()
            soundManager.playFailureSound()
            
        case .success:
            userProgress.addXP(25)
            addRandomReward()
            soundManager.playSuccessSound()
            
        case .neutral:
            // No immediate effect
            break
        }
        
        if hapticEnabled {
            switch consequence.type {
            case .death, .injury:
                HapticManager.shared.playFailure()
            case .success:
                HapticManager.shared.playSuccess()
            case .neutral:
                break
            }
        }
    }
    
    // MARK: - Data Management
    private func loadGameData() {
        userProgress = storageManager.loadUserProgress() ?? UserProgress()
        allStories = StoryDataManager.shared.getAllStories()
        inventory = storageManager.loadInventory() ?? []
        companions = storageManager.loadCompanions() ?? []
    }
    
    private func saveGameData() {
        storageManager.saveUserProgress(userProgress)
        storageManager.saveInventory(inventory)
        storageManager.saveCompanions(companions)
    }
    
    private func loadLeaderboard() {
        networkManager.fetchLeaderboard { [weak self] entries in
            DispatchQueue.main.async {
                self?.leaderboard = entries
            }
        }
    }
    
    // MARK: - Utility
    private func getDifficultyMultiplier() -> Int {
        switch difficultyMode {
        case .easy: return 1
        case .normal: return 2
        case .hard: return 3
        case .nightmare: return 5
        }
    }
    
    private func getXPForChallenge(_ challenge: StoryElement.Challenge) -> Int {
        let baseXP = 10
        let difficultyMultiplier: Int
        
        switch challenge.difficulty {
        case .easy: difficultyMultiplier = 1
        case .medium: difficultyMultiplier = 2
        case .hard: difficultyMultiplier = 3
        }
        
        return baseXP * difficultyMultiplier
    }
    
    func resetGame() {
        userProgress = UserProgress()
        currentStory = nil
        inventory.removeAll()
        companions.removeAll()
        currentLocation = .startingVillage
        unlocked = ["starting_village"]
        showingGameOver = false
        saveGameData()
        analyticsManager.trackEvent("game_reset")
    }
}

extension GameManager.TimeOfDay {
    static func fromHour(_ hour: Int) -> GameManager.TimeOfDay {
        switch hour {
        case 5...6: return .dawn
        case 7...11: return .morning
        case 12...17: return .afternoon
        case 18...20: return .evening
        case 21...23: return .night
        case 0...4: return .midnight
        default: return .morning
        }
    }
}
