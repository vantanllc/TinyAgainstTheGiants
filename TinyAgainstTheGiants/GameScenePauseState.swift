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
}

extension GameScenePauseState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    if let renderNode = gameScene.entityManager.getPlayerRenderNode() {
      let resumeButton = ButtonBuilder.getResumeButton()
      resumeButton.position = renderNode.position.applying(CGAffineTransform(translationX: 0, y: 100))
      gameScene.addChild(resumeButton)
    }
    
    gameScene.pause()
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    gameScene.childNode(withName: ButtonIdentifier.resume.rawValue)?.removeFromParent()
    gameScene.resume()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameSceneActiveState.Type
  }
}
