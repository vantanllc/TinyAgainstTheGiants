//
//  GameSceneActiveState.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/13/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class GameSceneActiveState: GKState {
  // MARK: States
  override func update(deltaTime seconds: TimeInterval) {
    super.update(deltaTime: seconds)
    gameScene.entityManager.update(deltaTime: seconds)
    
    time += seconds
    gameScene.timerNode.text = timeString
    
    if let percentage = gameScene.entityManager.getPlayerEntity()?.component(ofType: ChargeBarComponent.self)?.percentage, percentage.isZero {
      stateMachine?.enter(GameSceneFailState.self)
    }
  }
  
  // MARK: Lifecycle
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
  }

  // MARK: Properties
  unowned let gameScene: GameScene
  let startTime: TimeInterval = 0
  var time: TimeInterval = 0
  
  let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    
    return formatter
  }()
  
  var timeString: String {
    let components = NSDateComponents()
    components.second = Int(max(0.0, time))
    
    return timeFormatter.string(from: components as DateComponents)!
  }
}

extension GameSceneActiveState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    if previousState is GameSceneFailState {
      time = 0
    }
  }
}
