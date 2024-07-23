//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mayur on 01/07/24.
//

import SwiftUI

struct ContentView: View {
   @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var endGame = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var count = 0
    @State private var number = 0
    @State private var angleRotation = 0.0
    @State private var btnIndex: Int? = nil
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ],center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){ number in
                        Button {
                                btnIndex = number
                                angleRotation += 360
                                flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                                .opacity(btnIndex != number && btnIndex != nil ? 0.25 : 1)
                                .scaleEffect(btnIndex != number && btnIndex != nil ? 0.5 : 1)
                        }
                        .rotation3DEffect(Angle(degrees: angleRotation), axis: (x: 0, y: 1, z: 0))
                        .animation((btnIndex == number ? .default : nil), value: angleRotation)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Your score is \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Wrong"{
                Text("Its \(countries[number]) flag and Your score is \(score)")
            }
            Text("Your score is \(score)")
        }
        .alert("end game", isPresented: $endGame) {
            Button("ok", action: restartGame)
        } message: {
            Text("thats it!")
        }
    }
    
    func flagTapped(_ number: Int){
        count += 1
        self.number = number
        if number == correctAnswer{
                scoreTitle = "Correct"
                score += 1
        }else{
            scoreTitle = "Wrong"
            score -= 1
        }
        // using modern swift concurrency...
        Task {
            try? await Task.sleep(for: .seconds(0.5))
            showingScore = true
        }
        // using Dispatch queue...
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//            showingScore = true
//        }
    }
    func askQuestion(){
        btnIndex = nil
        if count == 8{
            endGame = true
            return
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame(){
        score = 0
        count = 0
    }
}

#Preview {
    ContentView()
}
