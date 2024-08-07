import SwiftUI
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var tigerNode: SKSpriteNode!
    let tigerCategory: UInt32 = 0x1 << 0
    let basketCategory: UInt32 = 0x1 << 1
    var pause = false
    var volume = false
    var score = 0
    
    var scoreLabel: SKLabelNode!
    var pauseOverlay: SKSpriteNode!
    var playButton: SKSpriteNode!
    var retryButton: SKSpriteNode!
    var menuButton: SKSpriteNode!
    var gameOverLabel: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        mainViewSettings()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == tigerCategory && contact.bodyB.categoryBitMask == basketCategory {
            contact.bodyA.node?.removeFromParent()
            incrementScore()
        } else if contact.bodyA.categoryBitMask == basketCategory && contact.bodyB.categoryBitMask == tigerCategory {
            contact.bodyB.node?.removeFromParent()
            incrementScore()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !pause {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            
            let maxHeight = size.height * 0.3
            let newY = min(max(location.y, 0), maxHeight)
            
            let action = SKAction.moveTo(x: location.x, duration: 0.1)
            let verticalAction = SKAction.moveTo(y: newY, duration: 0.1)
            
            tigerNode.run(action)
            tigerNode.run(verticalAction)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        switch touchedNode.name {
        case "BackButton", "MenuButton":
            navigateToMenuView()
            ButtonSoundManager.shared.playTapSound()
        case "SettingsButton":
            pauseGameAndShowSettings()
            ButtonSoundManager.shared.playTapSound()
        case "PlayButton":
            resumeGame()
            ButtonSoundManager.shared.playTapSound()
        case "RetryButton":
            restartGame()
            ButtonSoundManager.shared.playTapSound()
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if touchedNode.name == "ResumeButton" {
            self.isPaused = false
            pause = false
        } else if touchedNode.name == "MenuButton" {
            navigateToMenuView()
        } else if touchedNode.name == "RetryButton" {
            restartGame()
        }
    }
    
        
}

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.scaleMode = .resizeFill
        return scene
    }
    var body: some View {
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
    }
}

struct HighScore: Codable {
    var score: Int
}

extension UserDefaults {
    private enum Keys {
        static let highScores = "highScores"
    }
    
    var highScores: [HighScore] {
        get {
            guard let data = data(forKey: Keys.highScores) else { return [] }
            return (try? JSONDecoder().decode([HighScore].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            set(data, forKey: Keys.highScores)
        }
    }
}

func updateHighScores(with newScore: Int) {
    var highScores = UserDefaults.standard.highScores
    let newHighScore = HighScore(score: newScore)
    
    // Проверка на наличие одинакового значения
    if !highScores.contains(where: { $0.score == newScore }) {
        highScores.append(newHighScore)
        highScores.sort { $0.score > $1.score }
        
        if highScores.count > 3 {
            highScores = Array(highScores.prefix(3))
        }
        
        UserDefaults.standard.highScores = highScores
    }
}

#Preview {
    GameView()
}
