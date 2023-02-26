//
//  ContentView.swift
//  RPS
//
//  Created by Anastasia Kotova on 26.02.23.
//

import SwiftUI

struct ContentView: View {
    @State private var numberOfRounds = 0
    @State private var userScore = 0
    @State private var appChoice = Gesture.allCases.randomElement()!
    @State private var condition = WinCondition.allCases.randomElement()!
    @State private var answerTitle = ""
    @State private var finish = false
    
    var body: some View {
        ZStack {
            Color(red: 221/255, green: 190/255, blue: 169/255)
                .ignoresSafeArea()
            VStack {
                Text("Score \(userScore)")
                    .font(.title)
                Text("Tries \(numberOfRounds)/6")
                    .font(.title)
                Image(choosePicter())
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("You should \(condition == WinCondition.Win ? "win" : "lose")")
                    .font(.title)
                HStack {
                    Button {
                        checkAswer(userChoice: Gesture.Rock)
                    } label: {
                        Image("0")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    Button {
                        checkAswer(userChoice: Gesture.Paper)
                    } label: {
                        Image("1")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    Button {
                        checkAswer(userChoice: Gesture.Scissors)
                    } label: {
                        Image("2")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    
                }
                .alert("Finish", isPresented: $finish) {
                    Button("Restart") {
                        restartGame()
                    }
                } message: {
                    Text(chooseEndMessage())
                }
                Text(answerTitle)
                    .font(.title)
            }
        }
    }
    
    func choosePicter() -> String {
        switch appChoice {
        case Gesture.Rock:
            return "0"
        case Gesture.Paper:
            return "1"
        case Gesture.Scissors:
            return "2"
        }
    }
    
    func checkAswer(userChoice: Gesture) {
        let correctGesture = condition.checkGesture(userGesture: userChoice, appGecture: appChoice)
        
        if correctGesture.contains(userChoice) {
            answerTitle = "Correct!"
            userScore += 1
        } else {
            answerTitle = "Wrong! You had to choose \(correctGesture.description)"
        }
        numberOfRounds += 1
        appChoice = Gesture.allCases.randomElement()!
        condition = WinCondition.allCases.randomElement()!
        
        if numberOfRounds >= 6 {
            finish = true
        }
    }
    
    func restartGame() {
        numberOfRounds = 0
        userScore = 0
        appChoice = Gesture.allCases.randomElement()!
        condition = WinCondition.allCases.randomElement()!
        answerTitle = ""
    }
    
    func chooseEndMessage() -> String {
        switch userScore {
        case 0...2: return "Try harder next time"
        case 3...4: return "Not bad, but you can do better"
        case 5...6: return "Amazing! You are rock"
        default: return "OK"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Gesture: CaseIterable, CustomStringConvertible {
    
    case Rock
    case Paper
    case Scissors
    
    var description: String {
        switch self {
        case .Rock: return "Rock"
        case .Paper: return "Paper"
        case .Scissors: return "Scissors"
        }
    }
    
    func winsOver() -> Set<Gesture> {
        switch self {
        case .Rock: return [Gesture.Scissors]
        case .Paper: return [Gesture.Rock]
        case .Scissors: return [Gesture.Paper]
        }
    }
    
    func losesTo() -> Set<Gesture> {
        switch self {
        case .Rock: return [Gesture.Paper]
        case .Paper: return [Gesture.Scissors]
        case .Scissors: return [Gesture.Rock]
        }
    }
}

enum WinCondition: CaseIterable {
    case Win
    case Lose
    
    func checkGesture(userGesture: Gesture, appGecture: Gesture) -> Set<Gesture> {
        switch self {
        case .Win: return appGecture.losesTo()
        case .Lose: return appGecture.winsOver()
        }
    }
}
