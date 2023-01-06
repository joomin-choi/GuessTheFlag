//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by JooMin Choi on 26/08/2022.
//

import SwiftUI

struct ContentView: View {
    @State var showsAlert = false
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionNumber = 1
    @State private var questionsAsked = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
            
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
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
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                Text("Question:" + "\n" + "\(questionNumber)/10")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
                Button(action: {
                    self.showsAlert.toggle()
                }) {
                    Text("New Game")
                        .foregroundColor(.red)
                        .frame(maxWidth: 100)
                        .padding(.vertical, 10)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text("New Game"),
                        message: Text("Are you sure you want to start a new game?"),
                        primaryButton: .destructive(Text("New Game")) {
                            newGame()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if questionNumber < 10 {
                Button("Continue", action: askQuestion)
            } else {
                Button("Restart", action: newGame)
            }
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer && questionNumber < 10 {
            scoreTitle = "Correct!"
            questionsAsked += 1
            score += 1
        } else if number != correctAnswer && questionNumber < 10 {
            scoreTitle = "Wrong!" + "\n" + "The correct answer is \(countries[correctAnswer].uppercased())!"
            questionsAsked += 1
        } else if number == correctAnswer && questionNumber == 10 && questionsAsked < 10 {
            scoreTitle = "Correct! Game Over!"
        } else if number != correctAnswer && questionNumber == 10 && questionsAsked < 10 {
            scoreTitle = "Wrong!" + "\n" + "The correct answer is \(countries[correctAnswer].uppercased())! Game Over!"
        } else {
            scoreTitle = "Game over!"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionNumber += 1
    }
    
    func newGame() {
        questionNumber = 0
        questionsAsked = 0
        score = 0
        
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
