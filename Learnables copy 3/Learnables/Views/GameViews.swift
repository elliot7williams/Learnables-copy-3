//
//  GameViews.swift
//  Learnables
//
//  Created by Elliot Williams on 2025-07-02.
//

import SwiftUI

// MARK: - Challenge View
struct ChallengeView: View {
    let challenge: StoryElement.Challenge
    @ObservedObject var gameManager: GameManager
    @State private var selectedAnswer: Int? = nil
    @State private var timeRemaining: Double = 30.0
    @State private var showHint = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: min(20, geometry.size.height * 0.025)) {
                        // Challenge Header
                        VStack(spacing: 8) {
                            Text(challenge.type.rawValue.capitalized + " Challenge")
                                .font(.system(size: min(20, geometry.size.width * 0.05), weight: .bold))
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.8)
                                .lineLimit(1)
                            
                            Text(challenge.difficulty.rawValue.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(difficultyColor)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        // Timer
                        ProgressView(value: timeRemaining / 30.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: timeRemaining > 10 ? .green : .red))
                            .frame(height: 8)
                        
                        // Question
                        Text(challenge.question)
                            .font(.system(size: min(18, geometry.size.width * 0.045), weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(min(16, geometry.size.width * 0.04))
                            .minimumScaleFactor(0.8)
                        
                        // Options
                        VStack(spacing: min(12, geometry.size.height * 0.015)) {
                            ForEach(Array(challenge.options.enumerated()), id: \.offset) { index, option in
                                answerButton(option, index: index, geometry: geometry)
                            }
                        }
                        
                        // Action Buttons
                        HStack(spacing: min(20, geometry.size.width * 0.05)) {
                            Button("Hint") {
                                showHint.toggle()
                            }
                            .disabled(showHint)
                            .padding(min(12, geometry.size.width * 0.03))
                            .background(showHint ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .font(.system(size: min(16, geometry.size.width * 0.04)))
                            
                            Button("Submit") {
                                if let selected = selectedAnswer {
                                    gameManager.answerChallenge(selectedIndex: selected)
                                }
                            }
                            .disabled(selectedAnswer == nil)
                            .padding(min(12, geometry.size.width * 0.03))
                            .background(selectedAnswer == nil ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .font(.system(size: min(16, geometry.size.width * 0.04)))
                        }
                        
                        // Hint
                        if showHint {
                            Text("💡 Hint: Consider the context and common usage patterns")
                                .font(.system(size: min(14, geometry.size.width * 0.035)))
                                .foregroundColor(.yellow)
                                .padding(min(12, geometry.size.width * 0.03))
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(8)
                                .minimumScaleFactor(0.8)
                        }
                    }
                    .padding(min(16, geometry.size.width * 0.04))
                }
            }
        }
        .onAppear {
            startTimer()
        }
    }
    
    private var difficultyColor: Color {
        switch challenge.difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    private func answerButton(_ text: String, index: Int, geometry: GeometryProxy) -> some View {
        Button(action: {
            selectedAnswer = index
        }) {
            HStack {
                Text(text)
                    .foregroundColor(.white)
                    .font(.system(size: min(16, geometry.size.width * 0.04)))
                    .fontWeight(.medium)
                    .minimumScaleFactor(0.8)
                    .lineLimit(3)
                Spacer()
                if selectedAnswer == index {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: min(18, geometry.size.width * 0.045)))
                }
            }
            .padding(min(16, geometry.size.width * 0.04))
            .background(selectedAnswer == index ? Color.blue.opacity(0.8) : Color.white.opacity(0.2))
            .cornerRadius(10)
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            } else {
                timer.invalidate()
                // Auto-submit with no answer (penalty)
                gameManager.answerChallenge(selectedIndex: -1)
            }
        }
    }
}

// MARK: - Game Over View
struct GameOverView: View {
    @ObservedObject var gameManager: GameManager
    let onRestart: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: min(30, geometry.size.height * 0.04)) {
                        // Skull or sad emoji
                        Text("💀")
                            .font(.system(size: min(80, geometry.size.width * 0.2)))
                        
                        Text("Game Over")
                            .font(.system(size: min(34, geometry.size.width * 0.08), weight: .bold))
                            .foregroundColor(.red)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        
                        Text("You ran out of lives!")
                            .font(.system(size: min(20, geometry.size.width * 0.05)))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                        
                        // Stats
                        VStack(spacing: min(10, geometry.size.height * 0.015)) {
                            statRow("Stories Completed", value: "\(gameManager.userProgress.completedStories.count)", geometry: geometry)
                            statRow("Total XP Earned", value: "\(gameManager.userProgress.xp)", geometry: geometry)
                            statRow("Highest Level", value: "\(gameManager.userProgress.level)", geometry: geometry)
                            statRow("Learning Streak", value: "\(gameManager.userProgress.streak) days", geometry: geometry)
                        }
                        .padding(min(16, geometry.size.width * 0.04))
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(15)
                        
                        // Action Buttons
                        VStack(spacing: min(15, geometry.size.height * 0.02)) {
                            Button("Try Again") {
                                gameManager.resetGame()
                                onRestart()
                            }
                            .padding(min(16, geometry.size.width * 0.04))
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.system(size: min(18, geometry.size.width * 0.045), weight: .semibold))
                            
                            Button("Back to Menu") {
                                onRestart()
                            }
                            .padding(min(16, geometry.size.width * 0.04))
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.system(size: min(18, geometry.size.width * 0.045), weight: .semibold))
                        }
                    }
                    .padding(min(20, geometry.size.width * 0.05))
                }
            }
        }
    }
    
    private func statRow(_ title: String, value: String, geometry: GeometryProxy) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: min(16, geometry.size.width * 0.04)))
                .minimumScaleFactor(0.8)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
                .font(.system(size: min(16, geometry.size.width * 0.04)))
                .minimumScaleFactor(0.8)
        }
    }
}

// MARK: - Achievement Popup View
struct AchievementPopupView: View {
    let achievement: Achievement
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            // Achievement Icon
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            Text("Achievement Unlocked!")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(achievement.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
            
            Text(achievement.description)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Button("Awesome!") {
                onDismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(15)
        .padding()
    }
}

// MARK: - Weather Effect Views
struct RainEffectView: View {
    @State private var raindrops: [Raindrop] = []
    
    var body: some View {
        ZStack {
            ForEach(raindrops) { drop in
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 2, height: 10)
                    .position(x: drop.x, y: drop.y)
                    .animation(.linear(duration: drop.speed), value: drop.y)
            }
        }
        .onAppear {
            generateRain()
        }
    }
    
    private func generateRain() {
        raindrops = (0..<50).map { _ in
            Raindrop(
                x: CGFloat.random(in: 0...400),
                y: CGFloat.random(in: -100...0),
                speed: Double.random(in: 1...3)
            )
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in raindrops.indices {
                raindrops[i].y += CGFloat(raindrops[i].speed * 10)
                if raindrops[i].y > 800 {
                    raindrops[i].y = -10
                    raindrops[i].x = CGFloat.random(in: 0...400)
                }
            }
        }
    }
    
    struct Raindrop: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        let speed: Double
    }
}

struct SnowEffectView: View {
    @State private var snowflakes: [Snowflake] = []
    
    var body: some View {
        ZStack {
            ForEach(snowflakes) { flake in
                Text("❄️")
                    .font(.system(size: CGFloat.random(in: 10...20)))
                    .position(x: flake.x, y: flake.y)
                    .animation(.linear(duration: flake.speed), value: flake.y)
            }
        }
        .onAppear {
            generateSnow()
        }
    }
    
    private func generateSnow() {
        snowflakes = (0..<30).map { _ in
            Snowflake(
                x: CGFloat.random(in: 0...400),
                y: CGFloat.random(in: -100...0),
                speed: Double.random(in: 3...6)
            )
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in snowflakes.indices {
                snowflakes[i].y += CGFloat(snowflakes[i].speed * 5)
                if snowflakes[i].y > 800 {
                    snowflakes[i].y = -20
                    snowflakes[i].x = CGFloat.random(in: 0...400)
                }
            }
        }
    }
    
    struct Snowflake: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        let speed: Double
    }
}

struct StormEffectView: View {
    @State private var lightning = false
    
    var body: some View {
        ZStack {
            RainEffectView()
            
            if lightning {
                Color.white.opacity(0.3)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.1), value: lightning)
            }
        }
        .onAppear {
            startLightning()
        }
    }
    
    private func startLightning() {
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 3...8), repeats: true) { _ in
            lightning = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                lightning = false
            }
        }
    }
}

struct FogEffectView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
            
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 100...300))
                    .position(
                        x: CGFloat.random(in: 0...400),
                        y: CGFloat.random(in: 0...800)
                    )
                    .blur(radius: 20)
            }
        }
    }
}

struct SunEffectView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.yellow.opacity(0.3))
                .frame(width: 100, height: 100)
                .position(x: 350, y: 100)
                .blur(radius: 10)
            
            ForEach(0..<8, id: \.self) { i in
                Rectangle()
                    .fill(Color.yellow.opacity(0.4))
                    .frame(width: 2, height: 30)
                    .position(x: 350, y: 100)
                    .rotationEffect(.degrees(rotation + Double(i) * 45))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}
