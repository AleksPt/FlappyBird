//
//  PipeView.swift
//  FlappyBird
//
//  Created by Алексей on 07.11.2023.
//

import SwiftUI

struct PipeView: View {
    let topPipeHeight: CGFloat
    let pipeWidth: CGFloat
    let pipeSpacing: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let availableHeight = geometry.size.height - pipeSpacing
            let bottomPipeHeight = availableHeight - topPipeHeight
            
            VStack {
                // верхняя труба
                Image(.flappeBirdPipe)
                    .resizable()
                    .rotationEffect(.degrees(180))
                    .frame(width: pipeWidth, height: topPipeHeight)
                
                Spacer()
                    .frame(height: pipeSpacing)
                
                // нижняя труба
                Image(.flappeBirdPipe)
                    .resizable()
                    .frame(width: pipeWidth, height: bottomPipeHeight)
            }
        }
    }
}

#Preview {
    PipeView(topPipeHeight: 300, pipeWidth: 100, pipeSpacing: 200)
}
