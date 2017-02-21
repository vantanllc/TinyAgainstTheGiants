//
//  GameScenePauseState.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/16/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class GameScenePauseState: GKState {
  // MARK: Lifecycle
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
  }

  // MARK: Properties
  unowned let gameScene: GameScene
  var resumeButton: ButtonNode!
}

extension GameScenePauseState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    if let renderNode = gameScene.entityManager.getPlayerRenderNode() {
      resumeButton = ButtonBuilder.createButton(withIdentifier: .resume)
      resumeButton.position = renderNode.position.applying(CGAffineTransform(translationX: 0, y: 100))
      gameScene.addChild(resumeButton)
    }
    
    gameScene.pause()
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    resumeButton?.removeFromParent()
    gameScene.resume()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameSceneActiveState.Type
  }
}
