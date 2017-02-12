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
  var title: SKLabelNode!
}

extension TitleScreenState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    gameScene.camera?.position = CGPoint(x: gameScene.currentBackgroundTileMap.frame.midX, y: gameScene.currentBackgroundTileMap.frame.maxY)
    let startButton = ButtonBuilder.getStartButton()
    gameScene.camera?.addChild(startButton)
    
    title = createTitle(withText: "Tiny Giants")
    title.position = GameSceneActiveState.getPosition(forTimerNode: title, inScene: gameScene)
    gameScene.camera?.addChild(title)
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    title?.removeFromParent()
    gameScene.camera?.childNode(withName: ButtonIdentifier.start.rawValue)?.removeFromParent()
  }
  
  func createTitle(withText title: String) -> SKLabelNode {
    let title = SKLabelNode(text: title)
    title.fontSize = 50
    title.color = .blue
    title.verticalAlignmentMode = .top
    title.horizontalAlignmentMode = .center
    title.name = LabelIdentifier.title.rawValue
    title.zPosition = NodeLayerPosition.label
    return title
  }
}
