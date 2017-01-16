//
//  GameSceneFailState.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/15/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class GameSceneFailState: GKState {
  // MARK: Lifecycle
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
  }

  // MARK: Properties
  unowned let gameScene: GameScene
}

extension GameSceneFailState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    let body = gameScene.entityManager.getPlayerEntity()?.component(ofType: PhysicsComponent.self)?.physicsBody
    body?.isDynamic = false
    
    if let renderNode = gameScene.entityManager.getPlayerRenderNode() {
      let retryButton = ButtonBuilder.getRetryButton()
      retryButton.position = renderNode.position.applying(CGAffineTransform(translationX: 0, y: 100))
      gameScene.addChild(retryButton)
    }
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    gameScene.childNode(withName: ButtonIdentifier.retry.rawValue)?.removeFromParent()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameSceneActiveState.Type
  }
}
