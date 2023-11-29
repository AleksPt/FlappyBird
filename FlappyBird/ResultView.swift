//
//  ResultView.swift
//  FlappyBird
//
//  Created by Алексей on 07.11.2023.
//

import SwiftUI

struct ResultView: View {
    let score: Int
    let highScore: Int
    let resetAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .padding()
            Text("Счет: \(score)")
                .font(.title)
            Text("Рекорд: \(highScore)")
                .padding()
            Button("ЕЩЕ РАЗ", action: resetAction)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 10))
                .padding()
        }
        .background(.white.opacity(0.9))
        .clipShape(.rect(cornerRadius: 20))
        .padding()
    }
}

#Preview {
    ResultView(score: 5, highScore: 8, resetAction: {})
}
