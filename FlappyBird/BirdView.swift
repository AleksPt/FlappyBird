//
//  BirdView.swift
//  FlappyBird
//
//  Created by Алексей on 07.11.2023.
//

import SwiftUI

struct BirdView: View {
    let birdSize: CGFloat
    var body: some View {
        Image(.flappyBird)
            .resizable()
            .scaledToFit()
            .frame(width: birdSize, height: birdSize)
    }
}

#Preview {
    BirdView(birdSize: 80)
}
