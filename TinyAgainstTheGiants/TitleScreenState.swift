//
//  TitleScreenState.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 2/11/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class TitleScreenState: GKState {
  // MARK: Lifecycle
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
  }

  // MARK: Properties
  unowned let gameScene: GameScene
  var title: SKSpriteNode!
}

extension TitleScreenState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    let startButton = ButtonBuilder.getStartButton()
    startButton.position = startButton.position.applying(CGAffineTransform(translationX: 0, y: 100))
    gameScene.camera?.addChild(startButton)
    
    let creditsButton = ButtonBuilder.getCreditsButton()
    creditsButton.position.y = -100
    gameScene.camera?.addChild(creditsButton)
    
    title = createTitle()
    gameScene.camera?.addChild(title)
    
    gameScene.startNewGame()
    gameScene.physicsWorld.gravity = GameScene.Configuration.gravity
    
    let backgroundMusic = SKAudioNode(fileNamed: "TinyAgainstTheGiantsBackground.caf")
    backgroundMusic.autoplayLooped = true
    backgroundMusic.isPositional = false
    gameScene.addChild(backgroundMusic)
    backgroundMusic.run(SKAction.play())
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    title?.removeFromParent()
    gameScene.camera?.childNode(withName: ButtonIdentifier.start.rawValue)?.removeFromParent()
  }
  
  func createTitle() -> SKSpriteNode {
    let title = SKSpriteNode(imageNamed: "TinyGiantsTitle")
    title.name = LabelIdentifier.title.rawValue
    title.zPosition = NodeLayerPosition.label
    title.anchorPoint = CGPoint(x: 0.5, y: 1)
    title.position = CGPoint(x: 0, y: gameScene.size.height / 2)
    return title
  }
  
  func createLabel(withText title: String) -> SKLabelNode {
    let title = SKLabelNode(text: title)
    title.fontName = "Verdana-Bold"
    title.fontSize = 50
    title.color = .blue
    title.colorBlendFactor = 1
    title.verticalAlignmentMode = .top
    title.horizontalAlignmentMode = .center
    title.name = LabelIdentifier.title.rawValue
    title.zPosition = NodeLayerPosition.label
    return title
  }
}
