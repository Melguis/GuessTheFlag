//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jorge Henrique on 06/06/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingRestart = false
    @State private var scoreTitle = ""
    @State private var isRight = false
    @State private var wrongCountry = ""
    
    @State private var flagsCount = 0
    @State private var scoreCount = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.25), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Text("Guess the Flag")
                    Text(" - \(flagsCount)/8")
                }
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(scoreCount)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if isRight {
                Text("Your answer is correct! Your new score is \(scoreCount)")
            } else {
                Text("Your answer is Wrong! That's the flag of \(wrongCountry). Your new score is \(scoreCount)")
            }
        }
        
        .alert("Game over!", isPresented: $showingRestart) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Your final score is \(scoreCount). Click the button below to play again!")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreCount += Int.random(in: 1...50)
            scoreTitle = "Correct"
            isRight = true
        } else {
            if(scoreCount != 0) {
                scoreCount -= Int.random(in: 1...50)
                if scoreCount < 0 {
                    scoreCount = 0
                }
            }
            scoreTitle = "Wrong"
            isRight = false
            wrongCountry = countries[number]
        }
        
        showingScore = true
        
        if flagsCount < 8 {
            flagsCount += 1
        }
        
        if flagsCount == 8 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingRestart = true
            }
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame() {
        flagsCount = 0
        scoreCount = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
