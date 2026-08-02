//
//  GameFeatures.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import Foundation
import SwiftUI

// MARK: - Inventory System
struct InventoryItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let type: ItemType
    let rarity: Rarity
    let effects: [ItemEffect]
    let iconName: String
    let value: Int
    let stackable: Bool
    let maxStack: Int
    
    init(id: UUID = UUID(), name: String, description: String, type: ItemType, rarity: Rarity, effects: [ItemEffect], iconName: String, value: Int, stackable: Bool, maxStack: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.rarity = rarity
        self.effects = effects
        self.iconName = iconName
        self.value = value
        self.stackable = stackable
        self.maxStack = maxStack
    }
    
    enum ItemType: String, CaseIterable, Codable {
        case weapon = "weapon"
        case armor = "armor"
        case consumable = "consumable"
        case book = "book"
        case artifact = "artifact"
        case currency = "currency"
        case key = "key"
        case spell = "spell"
    }
    
    enum Rarity: String, CaseIterable, Codable {
        case common = "common"
        case uncommon = "uncommon"
        case rare = "rare"
        case epic = "epic"
        case legendary = "legendary"
        case mythic = "mythic"
        
        var color: Color {
            switch self {
            case .common: return .gray
            case .uncommon: return .green
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return .orange
            case .mythic: return .red
            }
        }
    }
    
    struct ItemEffect: Codable {
        let type: EffectType
        let value: Int
        let duration: TimeInterval?
        
        enum EffectType: String, CaseIterable, Codable {
            case xpBoost = "xp_boost"
            case lifeRestore = "life_restore"
            case skillBoost = "skill_boost"
            case timeFreeze = "time_freeze"
            case hintReveal = "hint_reveal"
            case doubleReward = "double_reward"
            case protection = "protection"
            case companion = "companion"
        }
    }
}

// MARK: - Companion System
struct Companion: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let type: CompanionType
    let level: Int
    let xp: Int
    let abilities: [CompanionAbility]
    let personality: Personality
    let backstory: String
    let dialogues: [String]
    let iconName: String
    let unlockCondition: UnlockCondition
    
    init(id: UUID = UUID(), name: String, description: String, type: CompanionType, level: Int, xp: Int, abilities: [CompanionAbility], personality: Personality, backstory: String, dialogues: [String], iconName: String, unlockCondition: UnlockCondition) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.level = level
        self.xp = xp
        self.abilities = abilities
        self.personality = personality
        self.backstory = backstory
        self.dialogues = dialogues
        self.iconName = iconName
        self.unlockCondition = unlockCondition
    }
    
    enum CompanionType: String, CaseIterable, Codable {
        case scholar = "scholar"
        case warrior = "warrior"
        case mage = "mage"
        case bard = "bard"
        case merchant = "merchant"
        case guide = "guide"
        case animal = "animal"
        case spirit = "spirit"
    }
    
    struct CompanionAbility: Codable {
        let name: String
        let description: String
        let cooldown: TimeInterval
        let effect: CompanionEffect
        
        enum CompanionEffect: String, CaseIterable, Codable {
            case provideHint = "provide_hint"
            case extraLives = "extra_lives"
            case bonusXP = "bonus_xp"
            case skipChallenge = "skip_challenge"
            case revealAnswer = "reveal_answer"
            case timeExtension = "time_extension"
            case encouragement = "encouragement"
            case translation = "translation"
        }
    }
    
    enum Personality: String, CaseIterable, Codable {
        case wise = "wise"
        case cheerful = "cheerful"
        case mysterious = "mysterious"
        case brave = "brave"
        case mischievous = "mischievous"
        case calm = "calm"
        case energetic = "energetic"
        case sarcastic = "sarcastic"
    }
    
    struct UnlockCondition: Codable {
        let type: ConditionType
        let value: Int
        let description: String
        
        enum ConditionType: String, CaseIterable, Codable {
            case level = "level"
            case storyComplete = "story_complete"
            case achievement = "achievement"
            case skillLevel = "skill_level"
            case streakDays = "streak_days"
            case itemFound = "item_found"
        }
    }
}

// MARK: - Location System
enum GameLocation: String, CaseIterable, Codable {
    case startingVillage = "starting_village"
    case enchantedForest = "enchanted_forest"
    case ancientLibrary = "ancient_library"
    case mysticCave = "mystic_cave"
    case skyTemple = "sky_temple"
    case dragonLair = "dragon_lair"
    case timePortal = "time_portal"
    case underwaterCity = "underwater_city"
    case cloudCastle = "cloud_castle"
    case shadowRealm = "shadow_realm"
    
    var displayName: String {
        switch self {
        case .startingVillage: return "Lexicon Village"
        case .enchantedForest: return "Whispering Woods"
        case .ancientLibrary: return "Archive of Ages"
        case .mysticCave: return "Crystal Caverns"
        case .skyTemple: return "Temple of Words"
        case .dragonLair: return "Grammar Dragon's Lair"
        case .timePortal: return "Temporal Gateway"
        case .underwaterCity: return "Aquatic Academy"
        case .cloudCastle: return "Nimbus Fortress"
        case .shadowRealm: return "Void of Silence"
        }
    }
    
    var description: String {
        switch self {
        case .startingVillage: return "A peaceful village where your journey begins"
        case .enchantedForest: return "Trees that whisper vocabulary lessons"
        case .ancientLibrary: return "Repository of all human knowledge"
        case .mysticCave: return "Echoing chambers test pronunciation"
        case .skyTemple: return "Floating sanctuary of advanced grammar"
        case .dragonLair: return "Home to the mighty Grammar Dragon"
        case .timePortal: return "Gateway to historical language events"
        case .underwaterCity: return "Submerged civilization of sea scholars"
        case .cloudCastle: return "Ethereal palace in the sky"
        case .shadowRealm: return "Dark dimension where words lose meaning"
        }
    }
    
    var backgroundImageName: String {
        return rawValue + "_background"
    }
    
    var ambientSoundName: String {
        return rawValue + "_ambient"
    }
}

// MARK: - Quests and Challenges
struct DailyQuest: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let type: QuestType
    let target: Int
    let progress: Int
    let reward: QuestReward
    let expirationDate: Date
    
    init(id: UUID = UUID(), title: String, description: String, type: QuestType, target: Int, progress: Int, reward: QuestReward, expirationDate: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.target = target
        self.progress = progress
        self.reward = reward
        self.expirationDate = expirationDate
    }
    
    enum QuestType: String, CaseIterable, Codable {
        case completeStories = "complete_stories"
        case answerCorrectly = "answer_correctly"
        case useSkill = "use_skill"
        case collectItems = "collect_items"
        case visitLocations = "visit_locations"
        case helpCompanions = "help_companions"
        case achieveStreak = "achieve_streak"
        case spendTime = "spend_time"
    }
    
    struct QuestReward: Codable {
        let xp: Int
        let items: [InventoryItem]
        let currency: Int
        let unlocks: [String]
    }
    
    var isCompleted: Bool {
        return progress >= target
    }
    
    var progressPercentage: Double {
        return min(Double(progress) / Double(target), 1.0)
    }
}

struct WeeklyChallenge: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let difficulty: ChallengeDifficulty
    let requirements: [ChallengeRequirement]
    let rewards: [ChallengeReward]
    let startDate: Date
    let endDate: Date
    let leaderboard: [LeaderboardEntry]
    
    init(id: UUID = UUID(), title: String, description: String, difficulty: ChallengeDifficulty, requirements: [ChallengeRequirement], rewards: [ChallengeReward], startDate: Date, endDate: Date, leaderboard: [LeaderboardEntry]) {
        self.id = id
        self.title = title
        self.description = description
        self.difficulty = difficulty
        self.requirements = requirements
        self.rewards = rewards
        self.startDate = startDate
        self.endDate = endDate
        self.leaderboard = leaderboard
    }
    
    enum ChallengeDifficulty: String, CaseIterable, Codable {
        case bronze = "bronze"
        case silver = "silver"
        case gold = "gold"
        case platinum = "platinum"
        case diamond = "diamond"
    }
    
    struct ChallengeRequirement: Codable {
        let description: String
        let target: Int
        let current: Int
        let type: RequirementType
        
        enum RequirementType: String, CaseIterable, Codable {
            case perfectChallenges = "perfect_challenges"
            case speedCompletion = "speed_completion"
            case noMistakes = "no_mistakes"
            case specificSkill = "specific_skill"
            case storyPath = "story_path"
        }
    }
    
    struct ChallengeReward: Codable {
        let tier: RewardTier
        let items: [InventoryItem]
        let title: String
        let badge: String
        
        enum RewardTier: String, CaseIterable, Codable {
            case participation = "participation"
            case bronze = "bronze"
            case silver = "silver"
            case gold = "gold"
            case grandPrize = "grand_prize"
        }
    }
}

struct SeasonalEvent: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let theme: EventTheme
    let startDate: Date
    let endDate: Date
    let specialStories: [UUID]
    let exclusiveRewards: [InventoryItem]
    let bonusMultiplier: Double
    let decorations: [String]
    
    init(id: UUID = UUID(), name: String, description: String, theme: EventTheme, startDate: Date, endDate: Date, specialStories: [UUID], exclusiveRewards: [InventoryItem], bonusMultiplier: Double, decorations: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.theme = theme
        self.startDate = startDate
        self.endDate = endDate
        self.specialStories = specialStories
        self.exclusiveRewards = exclusiveRewards
        self.bonusMultiplier = bonusMultiplier
        self.decorations = decorations
    }
    
    enum EventTheme: String, CaseIterable, Codable {
        case halloween = "halloween"
        case christmas = "christmas"
        case newYear = "new_year"
        case valentine = "valentine"
        case easter = "easter"
        case summer = "summer"
        case backToSchool = "back_to_school"
        case thanksgiving = "thanksgiving"
    }
    
    var isActive: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }
}

// MARK: - Leaderboard and Social
struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    let playerName: String
    let score: Int
    let level: Int
    let rank: Int
    let country: String
    let avatar: String
    let achievements: [Achievement.AchievementType]
    let lastActive: Date
    
    init(id: UUID = UUID(), playerName: String, score: Int, level: Int, rank: Int, country: String, avatar: String, achievements: [Achievement.AchievementType], lastActive: Date) {
        self.id = id
        self.playerName = playerName
        self.score = score
        self.level = level
        self.rank = rank
        self.country = country
        self.avatar = avatar
        self.achievements = achievements
        self.lastActive = lastActive
    }
    
    var displayRank: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "#\(rank)"
        }
    }
}

// MARK: - Notifications and Tutorial
struct GameNotification: Identifiable, Codable {
    let id: UUID
    let title: String
    let message: String
    let type: NotificationType
    let timestamp: Date
    let isRead: Bool
    let actionData: [String: Any]?
    
    init(id: UUID = UUID(), title: String, message: String, type: NotificationType, timestamp: Date, isRead: Bool, actionData: [String: Any]? = nil) {
        self.id = id
        self.title = title
        self.message = message
        self.type = type
        self.timestamp = timestamp
        self.isRead = isRead
        self.actionData = actionData
    }
    
    enum NotificationType: String, CaseIterable, Codable {
        case achievement = "achievement"
        case levelUp = "level_up"
        case questComplete = "quest_complete"
        case companionMessage = "companion_message"
        case eventStart = "event_start"
        case lifeRestored = "life_restored"
        case streakMilestone = "streak_milestone"
        case friendRequest = "friend_request"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        message = try container.decode(String.self, forKey: .message)
        type = try container.decode(NotificationType.self, forKey: .type)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        isRead = try container.decode(Bool.self, forKey: .isRead)
        actionData = nil // Simplified for encoding
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(message, forKey: .message)
        try container.encode(type, forKey: .type)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(isRead, forKey: .isRead)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, message, type, timestamp, isRead
    }
}

struct TutorialProgress: Codable {
    var completedSteps: Set<String> = []
    var currentStep: String?
    var isEnabled: Bool = true
    var showHints: Bool = true
    
    func isStepCompleted(_ step: String) -> Bool {
        return completedSteps.contains(step)
    }
    
    mutating func completeStep(_ step: String) {
        completedSteps.insert(step)
    }
}
