import SwiftUI
import SpriteKit

extension GameScene {
    //MARK: - Objects
    func mainViewSettings() {
        
        tigerNode = SKSpriteNode(imageNamed: "Basket")
        tigerNode.size = CGSize(width: size.width / 5 , height: size.height / 13)
        tigerNode.position = CGPoint(x: size.width / 2, y: 120)
        let smallerBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        tigerNode.physicsBody = smallerBody
        tigerNode.physicsBody?.isDynamic = false
        tigerNode.physicsBody?.categoryBitMask = basketCategory
        tigerNode.physicsBody?.contactTestBitMask = tigerCategory
        addChild(tigerNode)
        
        let backgroundNode = SKSpriteNode(imageNamed: "GameBackground")
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.size = size
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        let addLanternAction = SKAction.run { self.addTigers() }
        let waitAction = SKAction.wait(forDuration: 1.0)
        let sequenceAction = SKAction.sequence([addLanternAction, waitAction])
        run(SKAction.repeatForever(sequenceAction))
        
        let topLine = SKSpriteNode(imageNamed: "TopLine")
        topLine.size = CGSize(width: size.width, height: size.width / 5)
        topLine.position = CGPoint(x: size.width / 2, y: size.height - 100)
        topLine.name = "TopLine"
        topLine.zPosition = 1
        addChild(topLine)
        
        scoreLabel = SKLabelNode(fontNamed: "Courier")
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: 0, y: -scoreLabel.fontSize / 3)
        scoreLabel.zPosition = 2
        scoreLabel.text = "\(score)"
        topLine.addChild(scoreLabel)
        
        let backButton = SKSpriteNode(imageNamed: "BackToMenuButton")
        backButton.size = CGSize(width: size.width / 4.5, height: size.width / 4.5)
        backButton.position = CGPoint(x: 50, y: size.height - 100)
        backButton.name = "BackButton"
        backButton.zPosition = 1
        addChild(backButton)
        
        let settingsButton = SKSpriteNode(imageNamed: "PauseButton")
        settingsButton.size = CGSize(width: size.width / 4.5, height: size.width / 4.5)
        settingsButton.position = CGPoint(x: size.width - 50, y: size.height - 100)
        settingsButton.name = "SettingsButton"
        settingsButton.zPosition = 1
        addChild(settingsButton)
    
    }
    
    func addTigers() {
        let tigerNode = SKSpriteNode(imageNamed: "Tiger")
        tigerNode.size = CGSize(width: size.width / 6, height: size.height / 12)
        tigerNode.position = CGPoint(x: CGFloat.random(in: 25...(size.width - 25)), y:size.height + 50)
        tigerNode.physicsBody = SKPhysicsBody(rectangleOf: tigerNode.size)
        tigerNode.physicsBody?.isDynamic = true
        tigerNode.physicsBody?.categoryBitMask = tigerCategory
        tigerNode.physicsBody?.contactTestBitMask = basketCategory
        tigerNode.physicsBody?.collisionBitMask = 0
        addChild(tigerNode)
        let moveAction = SKAction.moveTo(y: -50, duration: 5.0)
        let removeAction = SKAction.run { [weak self] in
            if tigerNode.position.y < 0 {
                self?.gameOver()
            }
            tigerNode.removeFromParent()
        }
        tigerNode.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    func gameOver() {
        self.isPaused = true
        pause = true
        showGameOverOverlay()
        updateHighScores(with: score)
    }
    
    func restartGame() {
        if let view = self.view {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 1.0)
            view.presentScene(newScene, transition: transition)
        }
    }
    
    func navigateToMenuView() {
        if let view = self.view {
            let menuView = MenuView()
            let hostingController = UIHostingController(rootView: menuView)
            view.window?.rootViewController = hostingController
        }
    }
    
    func pauseGameAndShowSettings() {
        self.isPaused = true
        pause = true
        showPauseOverlay()
    }
    
    func resumeGame() {
        self.isPaused = false
        pause = false
        pauseOverlay.removeFromParent()
    }
    
    func showPauseOverlay() {
        pauseOverlay = SKSpriteNode(color: UIColor(white: 0, alpha: 0.7), size: size)
        pauseOverlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        pauseOverlay.zPosition = 10
        addChild(pauseOverlay)
        
        playButton = SKSpriteNode(imageNamed: "Play")
        playButton.size = CGSize(width: size.width / 3, height: size.width / 3)
        playButton.position = CGPoint(x: 0, y: 0)
        playButton.name = "PlayButton"
        playButton.zPosition = 11
        pauseOverlay.addChild(playButton)
    }
    
    func showGameOverOverlay() {
        pauseOverlay = SKSpriteNode(color: UIColor(white: 0, alpha: 0.7), size: size)
        pauseOverlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        pauseOverlay.zPosition = 10
        addChild(pauseOverlay)
        
        gameOverLabel = SKSpriteNode(imageNamed: "GameOverLabel")
        gameOverLabel.size = CGSize(width: size.width / 2, height: size.height / 4)
        gameOverLabel.position = CGPoint(x: 0, y: size.height / 5)
        gameOverLabel.zPosition = 11
        pauseOverlay.addChild(gameOverLabel)
        
        retryButton = SKSpriteNode(imageNamed: "RetryButton")
        retryButton.size = CGSize(width: size.width / 3, height: size.width / 3)
        retryButton.position = CGPoint(x: 0, y: 0)
        retryButton.name = "RetryButton"
        retryButton.zPosition = 11
        pauseOverlay.addChild(retryButton)
        
        menuButton = SKSpriteNode(imageNamed: "MenuButton")
        menuButton.size = CGSize(width: size.width / 2, height: size.height / 7)
        menuButton.position = CGPoint(x: 0, y: -size.height / 4)
        menuButton.name = "MenuButton"
        menuButton.zPosition = 11
        pauseOverlay.addChild(menuButton)
    }
}
