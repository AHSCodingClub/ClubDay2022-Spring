//
//  GameView.swift
//  SwiftPlaygrounds
//
//  Created by A. Zheng (github.com/aheze) on 1/10/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//


import SwiftUI

enum Player {
    case red
    case blue
    
    var color: Color {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        }
    }
}

struct Question {
    var text: String
    var answer: Int
}


struct GameView: View {
    @AppStorage("targetScore") var targetScore = 5
    @State var redScore = 0
    @State var blueScore = 0
    @State var redQuestion = Question(text: "2 + 2", answer: 4)
    @State var blueQuestion = Question(text: "2 + 2", answer: 4)
    @State var winner: Player?
    @State var currentGameID = UUID()
    
    var body: some View {
        VStack {
            GameSideView(player: .red, targetScore: targetScore, score: $redScore, question: $redQuestion, winner: $winner, currentGameID: $currentGameID)
                .scaleEffect(x: -1, y: -1)
            
            GameSideView(player: .blue, targetScore: targetScore, score: $blueScore, question: $blueQuestion, winner: $winner, currentGameID: $currentGameID)
        }
        .overlay {
            CenterView(
                targetScore: $targetScore,
                redScore: $redScore,
                blueScore: $blueScore,
                redQuestion: $redQuestion,
                blueQuestion: $blueQuestion
            )
            .offset(getCenterViewOffset())
        }
        .overlay {
            VStack {
                VStack {
                    if let winner = winner {
                        switch winner {
                        case .red:
                            Text("Red wins!")
                                .foregroundColor(.red)
                                .bold()
                            Text("Score: \(redScore)")
                        case .blue:
                            Text("Blue wins!")
                                .foregroundColor(.blue)
                                .bold()
                            Text("Score: \(blueScore)")
                        }
                    }
                }
                
                Button {
                    redScore = 0
                    blueScore = 0
                    redQuestion = Question(text: "2 + 2", answer: 4)
                    blueQuestion = Question(text: "2 + 2", answer: 4)
                    currentGameID = UUID()
                    
                    withAnimation(.spring()) {
                        winner = nil
                    }
                    
                } label: {
                    Text("Play Again?")
                }
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(.green)
                .cornerRadius(12)
            }
            .font(.largeTitle)
            .padding()
            .frame(maxWidth: 300, maxHeight: 300)
            .background(.ultraThickMaterial)
            .cornerRadius(16)
            .offset(x: 0, y: winner == nil ? 1000 : 0)
            .opacity(winner == nil ? 0 : 1)
        }
    }
    
    func getCenterViewOffset() -> CGSize {
        let difference = redScore - blueScore
        let offset = difference * 10
        
        if let winner = winner {
            switch winner {
            case .red:
                return CGSize(width: 0, height: 600)
            case .blue:
                return CGSize(width: 0, height: -600)
            }
        } else {
            return CGSize(width: 0, height: offset)
        }
    }
}

struct CenterView: View {
    @Binding var targetScore: Int
    @Binding var redScore: Int
    @Binding var blueScore: Int
    @Binding var redQuestion: Question
    @Binding var blueQuestion: Question
    @State var showingSettings = false
    
    var body: some View {
        ZStack {

            HStack {
                VStack(spacing: 16) {
                    Text("Score: \(redScore)")
                        .foregroundColor(.red)
                        .scaleEffect(x: -1, y: -1)
                    
                    Text("Score: \(blueScore)")
                        .foregroundColor(.blue)
                }
                .padding()
                Spacer()
            }
            .background(
                Rectangle()
                    .fill(.green)
                    .frame(height: 5)
            )
            .overlay(
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation {
                            showingSettings.toggle()
                        }
                    } label: {
                        
                        VStack {
                            if showingSettings {
                                Image(systemName: "xmark")
                            } else {
                                Image(systemName: "gearshape.fill")
                            }
                        }
                        .font(.title2.bold())
                        .foregroundColor(.green)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(Color.green, lineWidth: 5)
                        )
                    }
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(20)
                    .padding(.trailing, 10)
                }
            )
            
            VStack(spacing: 0) {
                QuestionSideView(question: $redQuestion)
                    .scaleEffect(x: -1, y: -1)
                    .padding()
                
                Rectangle()
                    .fill(.green)
                    .opacity(0.5)
                    .frame(height: 1)
                
                QuestionSideView(question: $blueQuestion)
                    .padding()
            }
            .frame(maxWidth: 150)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.green, lineWidth: 5)
            )
        }
        
        .overlay(
            VStack {
                Text("Change Target Score (\(targetScore))")
                
                HStack {
                    Group {
                        Button("5") { withAnimation { showingSettings = false }; targetScore = 5 }
                        Button("10") { withAnimation { showingSettings = false }; targetScore = 10 }
                        Button("20") { withAnimation { showingSettings = false }; targetScore = 20 }
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(12)
                }
            }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(16)
                .opacity(showingSettings ? 1 : 0)
                .offset(x: 0, y: showingSettings ? 0 : 80)
        )
    }
}
struct QuestionSideView: View {
    @Binding var question: Question
    
    var body: some View {
        Text(question.text)
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.semibold)
    }
}

struct GameButton: View {
    let color: Color
    let number: Int
    let action: (() -> Void)
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.title)
                .bold()
                .foregroundColor(color)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(16)
        }
    }
}
struct GameSideView: View {
    let player: Player
    let targetScore: Int
    @Binding var score: Int
    @Binding var question: Question
    @State var bubbles = [Bubble]()
    @Binding var winner: Player?
    @Binding var currentGameID: UUID
    
    var body: some View {
        VStack {
            HStack {
                GameButton(color: player.color, number: 1) { validate(attemptedAnswer: 1) }
                GameButton(color: player.color, number: 2) { validate(attemptedAnswer: 2) }
                GameButton(color: player.color, number: 3) { validate(attemptedAnswer: 3) }
            }
            HStack {
                GameButton(color: player.color, number: 4) { validate(attemptedAnswer: 4) }
                GameButton(color: player.color, number: 5) { validate(attemptedAnswer: 5) }
                GameButton(color: player.color, number: 6) { validate(attemptedAnswer: 6) }
            }
            HStack {
                GameButton(color: player.color, number: 7) { validate(attemptedAnswer: 7) }
                GameButton(color: player.color, number: 8) { validate(attemptedAnswer: 8) }
                GameButton(color: player.color, number: 9) { validate(attemptedAnswer: 9) }
            }
        }
        .padding()
        .padding(.top, 150)
        .background {
            ZStack {
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(uiColor: bubble.color),
                                    Color(uiColor: bubble.color.offset(by: 0.1))
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(bubble.opacity)
                        .frame(width: bubble.length, height: bubble.length)
                        .offset(bubble.offset)
                        .transition(.scale)
                }
            }
        }
        .onChange(of: winner) { _ in
            if winner != nil {
                let currentID = currentGameID
                for index in 0..<60 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat(index) / 15) {
                        if currentID == currentGameID {
                            addBubble(colorOffset: CGFloat(index) / 18)
                        }
                    }
                }
            } else {
                withAnimation {
                    bubbles = []
                }
            }
        }
    }
    
    func validate(attemptedAnswer: Int) {
        if question.answer == attemptedAnswer {
            withAnimation(.spring()) {
                score += 1
            }
            
            addBubble(colorOffset: CGFloat(score) / 18)
        } else {
            withAnimation(.spring()) {
                if score >= 1 {
                    score -= 1
                }
            }
            
            removeLastBubble()
        }
        
        if score >= targetScore {
            withAnimation(.spring()) {
                winner = player
            }
        } else {
            question = getQuestion()
        }
    }
    
    func getQuestion() -> Question {
        let isAddition = Bool.random()
        if isAddition {
            let firstNumber = Int.random(in: 1...4)
            let secondNumber = Int.random(in: 0...(9 - firstNumber))
            
            let text = "\(firstNumber) + \(secondNumber)"
            let answer = firstNumber + secondNumber
            return Question(text: text, answer: answer)
        } else {
            let firstNumber = Int.random(in: 5...9)
            let secondNumber = Int.random(in: 0...(firstNumber - 1))
            
            let text = "\(firstNumber) - \(secondNumber)"
            let answer = firstNumber - secondNumber
            return Question(text: text, answer: answer)
        }
    }
    
    func addBubble(colorOffset: CGFloat) {
        let uiColor = UIColor(player.color).offset(by: colorOffset)
        let newBubble = Bubble(
            length: CGFloat.random(in: 100...300),
            offset: CGSize(
                width: CGFloat.random(in: -240...240),
                height: CGFloat.random(in: -240...240)
            ),
            color: uiColor,
            opacity: 1
        )
        
        withAnimation(.spring(
            response: 0.8,
            dampingFraction: 0.6,
            blendDuration: 0.8
        )) {
            bubbles.append(newBubble)
        }
        withAnimation(.easeOut(duration: 10)) {
            if let bubbleIndex = bubbles.firstIndex(where: { $0.id == newBubble.id }) {
                bubbles[bubbleIndex].opacity = 0.2
            }
        }
    }
    
    func removeLastBubble() {
        withAnimation(.spring(
            response: 0.8,
            dampingFraction: 0.6,
            blendDuration: 0.8
        )) {
            if bubbles.count >= 1 {
                bubbles.removeLast()
            }
        }
    }
}
