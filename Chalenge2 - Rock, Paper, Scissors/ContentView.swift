//
//  ContentView.swift
//  Challenge2 - Rock, Paper, Scissors
//
//  Created by Vitali Vyucheiski on 6/9/22.
//

import SwiftUI

struct ContentView: View {
    let possibleMoves = ["✊🏼", "✋🏼", "✌🏼"]
    @State private var computerChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var questionCount = 1
    @State private var showEndGameAlert = false
    @State private var streakOfWins = 1
    @State private var streakOfLoses = 1
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Section {
                    VStack() {
                        Text("Computer's choice...")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("\(possibleMoves[computerChoice])")
                            .font(.system(size: 200))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Section {
                    VStack(spacing: 20) {
                        if shouldWin {
                            Text("Which one wins?")
                                .foregroundStyle(.green)
                                .font(.title)
                        } else {
                            Text("Which one loses?")
                                .foregroundStyle(.red)
                                .font(.title)
                        }
                        HStack {
                            ForEach(0..<3) { number in
                                Button(possibleMoves[number]) {
                                    play(choice: number)
                                }
                                .font(.system(size: 80))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title)
                    .foregroundStyle(.white)
                
                Spacer()
                Spacer()
            }
            .alert("The End", isPresented: $showEndGameAlert) {
                Button("Play Again", action: reset)
                    .foregroundStyle(.green, .primary)
            } message: {
                Text("Your final score: \(score)")
            }
            .padding()
        }
    }
    
    func play(choice: Int) {
        let winningMoves = [1, 2, 0]
        let didWin: Bool
        
        if shouldWin {
            didWin = choice == winningMoves[computerChoice]
        } else {
            didWin = winningMoves[choice] == computerChoice
        }
        
        if didWin {
            score = score + streakOfWins
            streakOfLoses = 1
            streakOfWins += 1
        } else {
            let nextScore = score - streakOfLoses
            
            if nextScore < 0 {
                score = 0
            } else {
                score = nextScore
            }
            streakOfWins = 1
            streakOfLoses += 1
        }
        
        if questionCount == 10 {
            showEndGameAlert = true
        } else {
            let nextMove = Int.random(in: 0...2)
            
            if nextMove == choice {
                let checkForNextMove = nextMove + 1
                
                if checkForNextMove == 3 {
                    computerChoice = Int.random(in: 0...1)
                } else {
                    computerChoice = checkForNextMove
                }
            } else {
                computerChoice = nextMove
            }
            
            shouldWin.toggle()
            questionCount += 1
        }
    }
    
    func reset() {
        score = 0
        questionCount = 0
        computerChoice = Int.random(in: 0...2)
        shouldWin.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 Pro Max")
    }
}
