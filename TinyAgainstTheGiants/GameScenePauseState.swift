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
  var musicButton: ButtonNode!
}

extension GameScenePauseState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    if let renderNode = gameScene.entityManager.getPlayerRenderNode() {
      resumeButton = ButtonBuilder.createButton(withIdentifier: .resume)
      resumeButton.position = renderNode.position.applying(CGAffineTransform(translationX: 0, y: 100))
      resumeButton.alpha = 0
      gameScene.addChild(resumeButton)
      resumeButton.fadeIn()
    }
    
    musicButton = Sound.current.isEnabled ? createMusicButton(withIdentifier: .musicOn) : createMusicButton(withIdentifier: .musicOff)
    musicButton.alpha = 0
    gameScene.camera?.addChild(musicButton)
    musicButton.fadeIn()
    
    gameScene.pause()
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    resumeButton?.removeFromParent()
    musicButton?.removeFromParent()
    gameScene.resume()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameSceneActiveState.Type
  }
}

extension GameScenePauseState {
  public func createMusicButton(withIdentifier identifier: ButtonIdentifier) -> ButtonNode {
    let button = ButtonBuilder.createButton(withIdentifier: identifier)
    button.anchorPoint = CGPoint(x: 1, y: 0)
    button.position = CGPoint(x: gameScene.size.width * 0.5, y: -gameScene.size.height * 0.5)
    return button
  }
}
