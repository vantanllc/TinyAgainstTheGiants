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
  var retryButton: ButtonNode!
}

extension GameSceneFailState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    
    if let renderNode = gameScene.entityManager.getPlayerRenderNode() {
      retryButton = ButtonBuilder.createButton(withIdentifier: .retry)
      retryButton.position = renderNode.position.applying(CGAffineTransform(translationX: 0, y: 100))
      gameScene.addChild(retryButton)
    }
    gameScene.pause()
    gameScene.gameSceneDelegate?.didEnteredFailState()
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    retryButton?.removeFromParent()
    gameScene.resume()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameSceneActiveState.Type
  }
}
