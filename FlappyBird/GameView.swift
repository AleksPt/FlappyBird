import SwiftUI

enum GameState {
    case ready, active, stopped
}

struct GameView: View {
    @AppStorage(wrappedValue: 0, "hightScore") private var highScore: Int
    
    @State private var birdVelocity = CGVector(dx: 0, dy: 0)
    @State private var birdPosition = CGPoint(x: 100, y: 300)
    
    @State private var pipeOffset: CGFloat = 0
    @State private var topPipeHeight = CGFloat.random(in: 100...500)
    
    @State private var passedPipe = false
    @State private var scores = 0
    @State private var gameState: GameState = .ready
    @State private var lastUpdateTime = Date()
    
    private let pipeWidth: CGFloat = 100
    private let pipeSpacing: CGFloat = 150
    
    private let jumpVelocity = -400
    private let gravity: CGFloat = 1000
    private let groundHeight: CGFloat = 100
    
    private let birdSize: CGFloat = 80
    private let birdRadius: CGFloat = 13
    
    private let timer = Timer.publish(
        every: 0.01,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Image(.flappyBirdBackground)
                        .resizable()
                        .ignoresSafeArea()
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: 0,
                                bottom: -50,
                                trailing: -30
                            )
                        )
                    
                    BirdView(birdSize: birdSize)
                        .position(birdPosition)
                    
                    PipeView(
                        topPipeHeight: topPipeHeight,
                        pipeWidth: pipeWidth,
                        pipeSpacing: pipeSpacing
                    )
                    .offset(x: geometry.size.width + pipeOffset)
                    
                    if gameState == .ready {
                        Button(action: playButtonAction) {
                            Image(systemName: "play.fill")
                        }
                        .font(Font.system(size: 150))
                        .foregroundStyle(.white)
                    }
                    
                    if gameState == .stopped {
                        ResultView(
                            score: scores,
                            highScore: highScore) {
                                resetGame()
                            }
                    }
                }
                .onTapGesture {
                    // устанавливаем вертикальную скорость вверх
                    birdVelocity = CGVector(dx: 0, dy: jumpVelocity)
                }
                .onReceive(timer) { currentTime in
                    guard gameState == .active else { return }
                    let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)

                    applyGravity(deltaTime: deltaTime)
                    updateBirdPosition(deltaTime: deltaTime)
                    checkBoundaries(geometry: geometry)
                    updatePipePosition(deltaTime: deltaTime)
                    resetPipePositionIfNeeded(geometry: geometry)
                    
                    if checkCollisions(geometry: geometry) {
                        gameState = .stopped
                    }
                    
                    updateScores(geometry: geometry)
                    
                    lastUpdateTime = currentTime
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Text("СЧЁТ: \(scores.formatted())")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
            }
        }
    }
    
    private func playButtonAction() {
        gameState = .active
        lastUpdateTime = Date()
    }
    
    private func applyGravity(deltaTime: TimeInterval) {
        birdVelocity.dy += CGFloat(gravity * deltaTime)
    }
    
    private func updateBirdPosition(deltaTime: TimeInterval) {
        birdPosition.y += birdVelocity.dy * CGFloat(deltaTime)
    }
    
    private func checkBoundaries(geometry: GeometryProxy) {
        // Проверка, не достигла ли птица верхней границы экрана
        if birdPosition.y <= 0 {
            birdPosition.y = 0
            gameState = .stopped
        }

        // Проверка, не достигла ли птица грунта
        if birdPosition.y > geometry.size.height - groundHeight {
            birdPosition.y = geometry.size.height - groundHeight
            birdVelocity.dy = 0
            gameState = .stopped
        }
    }
    
    private func checkCollisions(geometry: GeometryProxy) -> Bool {
        // Создаем прямоугольник вокруг птицы
        let birdFrame = CGRect(
            x: birdPosition.x - birdRadius / 2,
            y: birdPosition.y - birdRadius / 2,
            width: birdRadius,
            height: birdRadius
        )
        
        // Создаем прямоугольник вокруг верхнего столба
        let topPipeFrame = CGRect(
            x: geometry.size.width + pipeOffset,
            y: 0,
            width: pipeWidth,
            height: topPipeHeight
        )
        
        // Создаем прямоугольник вокруг нижнего столба
        let bottomPipeFrame = CGRect(
            x: geometry.size.width + pipeOffset,
            y: topPipeHeight + pipeSpacing,
            width: pipeWidth,
            height: topPipeHeight
        )
        
        return birdFrame.intersects(topPipeFrame) || birdFrame.intersects(bottomPipeFrame)
    }
    
    private func updatePipePosition(deltaTime: TimeInterval) {
        pipeOffset -= CGFloat(250 * deltaTime)
    }
    
    private func resetPipePositionIfNeeded(geometry: GeometryProxy) {
        if pipeOffset <= -geometry.size.width - pipeWidth {
            pipeOffset = 0
            topPipeHeight = CGFloat.random(in: 100...500)
        }
    }
    
    private func updateScores(geometry: GeometryProxy) {
        if pipeOffset + pipeWidth + geometry.size.width < birdPosition.x && !passedPipe {
            scores += 1
            
            if scores > highScore {
                highScore = scores
            }
            
            passedPipe = true
        } else if pipeOffset + geometry.size.width > birdPosition.x {
            passedPipe = false
        }
    }
    
    private func resetGame() {
        birdPosition = CGPoint(x: 100, y: 300)
        birdVelocity = CGVector(dx: 0, dy: 0)
        pipeOffset = 0
        topPipeHeight = CGFloat.random(in: 100...500)
        scores = 0
        gameState = .ready
    }
}

#Preview {
    GameView()
}
