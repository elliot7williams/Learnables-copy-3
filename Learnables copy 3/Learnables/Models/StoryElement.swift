//
//  StoryElement.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import Foundation

struct StoryElement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let choices: [Choice]
    let requiredSkillLevel: Int
    let xpReward: Int
    
    init(id: UUID = UUID(), title: String, description: String, choices: [Choice], requiredSkillLevel: Int, xpReward: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.choices = choices
        self.requiredSkillLevel = requiredSkillLevel
        self.xpReward = xpReward
    }
    
    struct Choice: Identifiable, Codable {
        let id: UUID
        let text: String
        let nextStoryId: UUID?
        let challenge: Challenge?
        let consequence: Consequence?
        
        init(id: UUID = UUID(), text: String, nextStoryId: UUID?, challenge: Challenge?, consequence: Consequence?) {
            self.id = id
            self.text = text
            self.nextStoryId = nextStoryId
            self.challenge = challenge
            self.consequence = consequence
        }
    }
    
    struct Challenge: Codable {
        let type: ChallengeType
        let question: String
        let options: [String]
        let correctAnswerIndex: Int
        let difficulty: Difficulty
        
        enum ChallengeType: String, CaseIterable, Codable {
            case vocabulary = "vocabulary"
            case grammar = "grammar"
            case reading = "reading"
            case listening = "listening"
            case writing = "writing"
        }
        
        enum Difficulty: String, CaseIterable, Codable {
            case easy = "easy"
            case medium = "medium"
            case hard = "hard"
        }
    }
    
    struct Consequence: Codable {
        let type: ConsequenceType
        let description: String
        
        enum ConsequenceType: String, CaseIterable, Codable {
            case death = "death"
            case injury = "injury"
            case success = "success"
            case neutral = "neutral"
        }
    }
}
