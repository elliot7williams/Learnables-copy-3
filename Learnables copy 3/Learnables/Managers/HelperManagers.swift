//
//  HelperManagers.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import Foundation

// MARK: - Inventory Manager
class InventoryManager {
    static func getAvailableRewards(userLevel: Int) -> [InventoryItem] {
        let commonItems = [
            InventoryItem(
                name: "Health Potion",
                description: "Restores one life",
                type: .consumable,
                rarity: .common,
                effects: [InventoryItem.ItemEffect(type: .lifeRestore, value: 1, duration: nil)],
                iconName: "health_potion",
                value: 10,
                stackable: true,
                maxStack: 5
            ),
            InventoryItem(
                name: "XP Scroll",
                description: "Grants bonus experience",
                type: .consumable,
                rarity: .uncommon,
                effects: [InventoryItem.ItemEffect(type: .xpBoost, value: 50, duration: nil)],
                iconName: "xp_scroll",
                value: 25,
                stackable: true,
                maxStack: 10
            )
        ]
        
        let rareItems = [
            InventoryItem(
                name: "Grammar Shield",
                description: "Protects from one grammar mistake",
                type: .armor,
                rarity: .rare,
                effects: [InventoryItem.ItemEffect(type: .protection, value: 1, duration: 300)],
                iconName: "grammar_shield",
                value: 100,
                stackable: false,
                maxStack: 1
            ),
            InventoryItem(
                name: "Wisdom Tome",
                description: "Reveals hints for difficult questions",
                type: .book,
                rarity: .epic,
                effects: [InventoryItem.ItemEffect(type: .hintReveal, value: 3, duration: nil)],
                iconName: "wisdom_tome",
                value: 250,
                stackable: false,
                maxStack: 1
            )
        ]
        
        let legendaryItems = [
            InventoryItem(
                name: "Dragon's Vocabulary",
                description: "Ancient knowledge of all words",
                type: .artifact,
                rarity: .legendary,
                effects: [
                    InventoryItem.ItemEffect(type: .skillBoost, value: 5, duration: 600),
                    InventoryItem.ItemEffect(type: .doubleReward, value: 1, duration: 600)
                ],
                iconName: "dragon_vocabulary",
                value: 1000,
                stackable: false,
                maxStack: 1
            )
        ]
        
        var availableItems = commonItems
        
        if userLevel >= 5 {
            availableItems.append(contentsOf: rareItems)
        }
        
        if userLevel >= 15 {
            availableItems.append(contentsOf: legendaryItems)
        }
        
        return availableItems
    }
}

// MARK: - Location Manager
class LocationManager {
    static func getUnlockedLocations(for story: StoryElement, userProgress: UserProgress) -> Set<String> {
        var newLocations: Set<String> = []
        
        // Logic to unlock locations based on story completion
        let completedCount = userProgress.completedStories.count
        let userLevel = userProgress.level
        
        if completedCount >= 5 && !userProgress.unlocked.contains("enchanted_forest") {
            newLocations.insert("enchanted_forest")
        }
        
        if completedCount >= 10 && userLevel >= 5 {
            newLocations.insert("ancient_library")
        }
        
        if completedCount >= 20 && userLevel >= 10 {
            newLocations.insert("mystic_cave")
        }
        
        if completedCount >= 35 && userLevel >= 15 {
            newLocations.insert("sky_temple")
        }
        
        if completedCount >= 50 && userLevel >= 20 {
            newLocations.insert("dragon_lair")
        }
        
        if completedCount >= 75 && userLevel >= 25 {
            newLocations.insert("time_portal")
        }
        
        if completedCount >= 100 && userLevel >= 30 {
            newLocations.insert("underwater_city")
        }
        
        if completedCount >= 150 && userLevel >= 40 {
            newLocations.insert("cloud_castle")
        }
        
        if completedCount >= 200 && userLevel >= 50 {
            newLocations.insert("shadow_realm")
        }
        
        return newLocations
    }
}

// MARK: - Daily Quest Generator
class DailyQuestGenerator {
    static func generateQuests(for date: Date, userLevel: Int) -> [DailyQuest] {
        let questTemplates = [
            ("Story Explorer", "Complete {target} stories", DailyQuest.QuestType.completeStories, 3),
            ("Accuracy Master", "Answer {target} questions correctly", DailyQuest.QuestType.answerCorrectly, 10),
            ("Vocabulary Builder", "Use vocabulary skills {target} times", DailyQuest.QuestType.useSkill, 5),
            ("Treasure Hunter", "Collect {target} items", DailyQuest.QuestType.collectItems, 2),
            ("Explorer", "Visit {target} different locations", DailyQuest.QuestType.visitLocations, 2),
            ("Helper", "Interact with companions {target} times", DailyQuest.QuestType.helpCompanions, 3),
            ("Dedication", "Maintain your streak for {target} day(s)", DailyQuest.QuestType.achieveStreak, 1),
            ("Scholar", "Spend {target} minutes learning", DailyQuest.QuestType.spendTime, 30)
        ]
        
        var quests: [DailyQuest] = []
        let numberOfQuests = min(3, questTemplates.count)
        let shuffledTemplates = questTemplates.shuffled()
        
        for i in 0..<numberOfQuests {
            let template = shuffledTemplates[i]
            let adjustedTarget = adjustTargetForLevel(template.3, userLevel: userLevel)
            
            let quest = DailyQuest(
                title: template.0,
                description: template.1.replacingOccurrences(of: "{target}", with: "\(adjustedTarget)"),
                type: template.2,
                target: adjustedTarget,
                progress: 0,
                reward: generateQuestReward(userLevel: userLevel),
                expirationDate: Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
            )
            
            quests.append(quest)
        }
        
        return quests
    }
    
    private static func adjustTargetForLevel(_ baseTarget: Int, userLevel: Int) -> Int {
        let multiplier = 1.0 + (Double(userLevel) * 0.1)
        return max(1, Int(Double(baseTarget) * multiplier))
    }
    
    private static func generateQuestReward(userLevel: Int) -> DailyQuest.QuestReward {
        let baseXP = 50 + (userLevel * 10)
        let currency = 25 + (userLevel * 5)
        let items = InventoryManager.getAvailableRewards(userLevel: userLevel).prefix(1).map { $0 }
        
        return DailyQuest.QuestReward(
            xp: baseXP,
            items: Array(items),
            currency: currency,
            unlocks: []
        )
    }
}

// MARK: - Weekly Challenge Generator
class WeeklyChallengeGenerator {
    static func generateChallenge(for date: Date, userLevel: Int) -> WeeklyChallenge {
        let challengeTemplates = [
            ("Grammar Gauntlet", "Master the art of perfect grammar", WeeklyChallenge.ChallengeDifficulty.gold),
            ("Vocabulary Voyage", "Expand your word knowledge to new heights", WeeklyChallenge.ChallengeDifficulty.silver),
            ("Speed Scholar", "Complete challenges at lightning speed", WeeklyChallenge.ChallengeDifficulty.platinum),
            ("Perfect Precision", "Achieve flawless accuracy", WeeklyChallenge.ChallengeDifficulty.diamond),
            ("Story Sage", "Navigate through complex narratives", WeeklyChallenge.ChallengeDifficulty.bronze)
        ]
        
        let template = challengeTemplates.randomElement() ?? challengeTemplates[0]
        
        let requirements = generateChallengeRequirements(difficulty: template.2, userLevel: userLevel)
        let rewards = generateChallengeRewards(difficulty: template.2, userLevel: userLevel)
        
        return WeeklyChallenge(
            title: template.0,
            description: template.1,
            difficulty: template.2,
            requirements: requirements,
            rewards: rewards,
            startDate: date,
            endDate: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: date) ?? date,
            leaderboard: []
        )
    }
    
    private static func generateChallengeRequirements(difficulty: WeeklyChallenge.ChallengeDifficulty, userLevel: Int) -> [WeeklyChallenge.ChallengeRequirement] {
        
        // Scale targets based on user level
        let levelMultiplier = max(1.0, Double(userLevel) / 10.0)
        
        let baseTargets = [
            WeeklyChallenge.ChallengeRequirement(
                description: "Complete challenges perfectly",
                target: Int(Double(difficulty == .diamond ? 20 : 10) * levelMultiplier),
                current: 0,
                type: .perfectChallenges
            ),
            WeeklyChallenge.ChallengeRequirement(
                description: "Complete stories in under 2 minutes",
                target: Int(Double(difficulty == .platinum ? 15 : 5) * levelMultiplier),
                current: 0,
                type: .speedCompletion
            ),
            WeeklyChallenge.ChallengeRequirement(
                description: "Answer without making mistakes",
                target: Int(Double(difficulty == .diamond ? 50 : 25) * levelMultiplier),
                current: 0,
                type: .noMistakes
            )
        ]
        
        return Array(baseTargets.prefix(2)) // Take first 2 requirements
    }
    
    private static func generateChallengeRewards(difficulty: WeeklyChallenge.ChallengeDifficulty, userLevel: Int) -> [WeeklyChallenge.ChallengeReward] {
        let rewards = [
            WeeklyChallenge.ChallengeReward(
                tier: .participation,
                items: [],
                title: "Participant",
                badge: "participation_badge"
            ),
            WeeklyChallenge.ChallengeReward(
                tier: .bronze,
                items: InventoryManager.getAvailableRewards(userLevel: userLevel).filter { $0.rarity == .uncommon },
                title: "Bronze Achiever",
                badge: "bronze_badge"
            ),
            WeeklyChallenge.ChallengeReward(
                tier: .silver,
                items: InventoryManager.getAvailableRewards(userLevel: userLevel).filter { $0.rarity == .rare },
                title: "Silver Champion",
                badge: "silver_badge"
            ),
            WeeklyChallenge.ChallengeReward(
                tier: .gold,
                items: InventoryManager.getAvailableRewards(userLevel: userLevel).filter { $0.rarity == .epic },
                title: "Gold Master",
                badge: "gold_badge"
            ),
            WeeklyChallenge.ChallengeReward(
                tier: .grandPrize,
                items: InventoryManager.getAvailableRewards(userLevel: userLevel).filter { $0.rarity == .legendary },
                title: "Grand Champion",
                badge: "grand_champion_badge"
            )
        ]
        
        return rewards
    }
}

// MARK: - Seasonal Event Manager
class SeasonalEventManager {
    static func getCurrentEvent() -> SeasonalEvent? {
        let now = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        
        // Halloween Event (October)
        if month == 10 {
            return createHalloweenEvent(for: now)
        }
        
        // Christmas Event (December)
        if month == 12 && day >= 15 {
            return createChristmasEvent(for: now)
        }
        
        // New Year Event (January 1-7)
        if month == 1 && day <= 7 {
            return createNewYearEvent(for: now)
        }
        
        // Valentine's Day Event (February 14 ± 3 days)
        if month == 2 && day >= 11 && day <= 17 {
            return createValentineEvent(for: now)
        }
        
        // Back to School Event (September)
        if month == 9 {
            return createBackToSchoolEvent(for: now)
        }
        
        return nil
    }
    
    private static func createHalloweenEvent(for date: Date) -> SeasonalEvent {
        return SeasonalEvent(
            name: "Spooky Vocabulary Hunt",
            description: "Learn eerie words and ghostly grammar in this haunted adventure!",
            theme: .halloween,
            startDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 10, day: 1)) ?? date,
            endDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 10, day: 31)) ?? date,
            specialStories: [],
            exclusiveRewards: [],
            bonusMultiplier: 1.5,
            decorations: ["pumpkins", "bats", "spider_webs", "ghosts"]
        )
    }
    
    private static func createChristmasEvent(for date: Date) -> SeasonalEvent {
        return SeasonalEvent(
            name: "Winter Wonderland Words",
            description: "Celebrate the holidays with festive vocabulary and cheerful grammar!",
            theme: .christmas,
            startDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 12, day: 15)) ?? date,
            endDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 12, day: 31)) ?? date,
            specialStories: [],
            exclusiveRewards: [],
            bonusMultiplier: 2.0,
            decorations: ["snow", "christmas_trees", "presents", "lights"]
        )
    }
    
    private static func createNewYearEvent(for date: Date) -> SeasonalEvent {
        return SeasonalEvent(
            name: "New Year, New Words",
            description: "Start the year with fresh vocabulary and renewed grammar skills!",
            theme: .newYear,
            startDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 1, day: 1)) ?? date,
            endDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 1, day: 7)) ?? date,
            specialStories: [],
            exclusiveRewards: [],
            bonusMultiplier: 1.25,
            decorations: ["fireworks", "confetti", "balloons", "party_hats"]
        )
    }
    
    private static func createValentineEvent(for date: Date) -> SeasonalEvent {
        return SeasonalEvent(
            name: "Love for Language",
            description: "Express your love for learning with romantic vocabulary!",
            theme: .valentine,
            startDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 2, day: 11)) ?? date,
            endDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 2, day: 17)) ?? date,
            specialStories: [],
            exclusiveRewards: [],
            bonusMultiplier: 1.3,
            decorations: ["hearts", "roses", "cupids", "love_letters"]
        )
    }
    
    private static func createBackToSchoolEvent(for date: Date) -> SeasonalEvent {
        return SeasonalEvent(
            name: "Academic Excellence",
            description: "Sharpen your skills for the new school year!",
            theme: .backToSchool,
            startDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 9, day: 1)) ?? date,
            endDate: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 9, day: 30)) ?? date,
            specialStories: [],
            exclusiveRewards: [],
            bonusMultiplier: 1.4,
            decorations: ["books", "pencils", "apples", "graduation_caps"]
        )
    }
}
