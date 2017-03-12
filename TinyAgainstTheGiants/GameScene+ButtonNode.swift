//
//  GameScene+ButtonNode.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/15/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import SpriteKit

extension GameScene: ButtonRespondable {
  func buttonTriggered(button: ButtonNode) {
    guard let buttonIdentifier = button.buttonIdentifier else {
      return
    }
    
    switch buttonIdentifier {
    case .retry:
      entityManager.removeAll()
      startNewGame()
      stateMachine.enter(GameSceneActiveState.self)
    case .pause:
      stateMachine.enter(GameScenePauseState.self)
    case .resume:
      stateMachine.enter(GameSceneActiveState.self)
    case .start:
      stateMachine.enter(GameSceneActiveState.self)
    case .credits:
      showCredits()
    case .musicOn:
      Sound.current.isEnabled = false
    case .musicOff:
      Sound.current.isEnabled = true
    }
  }
}
