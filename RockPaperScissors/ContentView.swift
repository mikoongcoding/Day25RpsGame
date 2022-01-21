//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Mi Gyeong Park on 2022/01/15.
//

import SwiftUI

struct descriptionFont : View {
    var text : String
    var body : some View {
        Text(text)
            .font(.largeTitle.bold())
    }
}
struct varFont : View {
    var text : String
    var body : some View {
        Text(text)
            .font(.largeTitle.weight(.bold))
            .foregroundColor(Color.black)
    }
}

struct ContentView: View {
    @State private var rps = ["Rock", "Paper", "Scissors"]
    
    @State private var appCurrentMove = Int.random(in: 0...2)
    @State private var shouldPlayerWin = Bool.random()
    
    @State private var usersScore = 0
    @State private var appsScore = 0
    
    @State private var willshowResult = false
    @State private var showResult = ""
    
    //타이머
    private let intialTime = 30
    @State private var timeRemaining = 30
    let timer = Timer.publish(every: 1, on: .main, in:.common).autoconnect()
    
    //게임 결과 알림 팝업
    @State private var showingFinalAlert = false
    @State private var userWin = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red:0.83, green: 0.98, blue: 0.96)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack (spacing: 10){
                VStack {
                    HStack {
                        descriptionFont(text: "App  \(appsScore)")
                        Text("VS")
                            .foregroundColor(.orange)
                            .font(.largeTitle.bold())
                        descriptionFont(text: "\(usersScore)  Player")
                    }
                    Text("Time : \(timeRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                    Spacer()
                    HStack {
                        descriptionFont(text: "App's move :")
                        Image(rps[appCurrentMove])
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                    
                }
                Spacer()
                HStack {
                    Text("You should \(shouldPlayerWin ? "Win" : "Lose")")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .background(.green)
                
                Spacer()
                
                HStack {
                    Text(willshowResult ? "\(showResult)" : "")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.orange)

                Spacer()
                
                VStack {
                    descriptionFont(text: "Your turn")
                    HStack {
                        ForEach(0..<3) { number in
                            Button {
                                whoGetScore(usersRPS: number)
                                nextGame()
                            } label: {
                                Image(rps[number])
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 100, height: 100, alignment: .center)
                                
                            }
                        }
                        
                    }
                   
                }
                Spacer()
                
            }
        }
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                endGame()
            }
        }
        .alert("Great!", isPresented: $showingFinalAlert) {
            Button("Restart", action: restartGame)
        } message: {
            Text("You got \(usersScore) points in 30 seconds! \(userWin ? " and You Win!" : " but App Win")")
        }
    }
    
    func whoWin() {
        if usersScore > appsScore {
            userWin = true
        }
    }
    
    func endGame() {
        whoWin()
        showingFinalAlert = true
    }
    
    func restartGame() {
        timeRemaining = intialTime
        usersScore = 0
        appsScore = 0
        showResult = ""
        appCurrentMove = Int.random(in: 0...2)
        shouldPlayerWin.toggle()
    }
    
    func nextGame() {
        appCurrentMove = Int.random(in: 0...2)
        shouldPlayerWin.toggle()
    }
    
    func whoGetScore(usersRPS: Int) {
        let userWin = rpsRules(usersRPS: usersRPS)
        if rps[appCurrentMove] == rps[usersRPS] {
            showResult = "Draw!"
        }else{
            if shouldPlayerWin == userWin {
                 usersScore += 1
                 showResult = "You Win!"
            } else {
                 appsScore += 1
                 showResult = "App Win!"
            }
        }
        willshowResult = true
        print("usersScore : \(usersScore) & appsScore : \(appsScore)")
    }
    
    func rpsRules(usersRPS: Int) -> Bool {
        var userWin = false
        switch rps[appCurrentMove] {
        case "Rock":
            if rps[usersRPS] == "Paper" {
                userWin = true
            } else if rps[usersRPS] == "Scissors" {
                userWin = false
            }
            break
        case "Paper":
            if rps[usersRPS] == "Scissors" {
                userWin = true
            } else if rps[usersRPS] == "Rock" {
                userWin = false
            }
            break
        case "Scissors":
            if rps[usersRPS] == "Rock" {
                userWin = true
            } else if rps[usersRPS] == "Paper" {
                userWin = false
            }
            break
        default:
            userWin = false
            break
        }
        return userWin
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
