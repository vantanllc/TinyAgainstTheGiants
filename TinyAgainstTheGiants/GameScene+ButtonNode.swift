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
      backgroundAudio.pause()
      updateButton(button, withIdentifier: .musicOff)
      for enemy in entityManager.getEnemyEntities()! {
        if let enemy = enemy as? EnemyEntity {
          enemy.removeAudioNode()
        }
      }
    case .musicOff:
      Sound.current.isEnabled = true
      backgroundAudio.play()
      updateButton(button, withIdentifier: .musicOn)
      for enemy in entityManager.getEnemyEntities()! {
        if let enemy = enemy as? EnemyEntity {
          enemy.addAudioNode()
        }
      }
    }
    
    if Sound.current.isEnabled {
      buttonAudio.play()
    }
  }
  
  func updateButton(_ button: ButtonNode, withIdentifier identifier: ButtonIdentifier) {
    let texture = SKTexture(imageNamed: identifier.rawValue.capitalizingFirstLetter())
    button.texture = texture
    button.name = identifier.rawValue
  }
}
