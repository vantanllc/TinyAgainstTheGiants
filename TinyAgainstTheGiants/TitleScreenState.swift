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
  var startButton: ButtonNode!
  var creditsButton: ButtonNode!
}

extension TitleScreenState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    addStartButton()
    addCreditsButton()
    
    title = createTitle()
    gameScene.camera?.addChild(title)
    
    gameScene.startNewGame()
    gameScene.physicsWorld.gravity = GameScene.Configuration.gravity
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    title?.removeFromParent()
    startButton?.removeFromParent()
    creditsButton?.removeFromParent()
  }
  
  func addCreditsButton() {
    creditsButton = ButtonBuilder.createButton(withIdentifier: .credits)
    creditsButton.anchorPoint = CGPoint(x: 1, y: 0)
    creditsButton.position = CGPoint(x: gameScene.size.width * 0.5, y: -gameScene.size.height * 0.5)
    gameScene.camera?.addChild(creditsButton)
  }
  
  func addStartButton() {
    startButton = ButtonBuilder.createButton(withIdentifier: .start)
    startButton.position = startButton.position.applying(CGAffineTransform(translationX: 0, y: 100))
    gameScene.camera?.addChild(startButton)
  }
  
  func createTitle() -> SKSpriteNode {
    let title = SKSpriteNode(imageNamed: "TinyGiantsTitle")
    title.name = LabelIdentifier.title.rawValue
    title.zPosition = NodeLayerPosition.label
    title.anchorPoint = CGPoint(x: 0.5, y: 1)
    title.position = CGPoint(x: 0, y: gameScene.size.height / 2)
    return title
  }
}
