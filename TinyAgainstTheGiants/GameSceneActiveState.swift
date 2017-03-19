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
    
    gameScene.enemySpawnTime -= seconds
    
    if let enemies = gameScene.entityManager.getEnemyEntities() {
      for enemy in enemies {
        if let node = enemy.component(ofType: RenderComponent.self)?.node, node.position.y > gameScene.previousBackgroundTileMap.frame.maxY {
          gameScene.entityManager.remove(entity: enemy)
        }
      }
      
      if enemies.count < gameScene.maxEnemyCount, gameScene.enemySpawnTime.isLessThanOrEqualTo(0) {
        gameScene.addEnemy()
        gameScene.enemySpawnTime = gameScene.enemySpawnCoolDown
      }
    }
    
    time += seconds
    if let timerNode = gameScene.camera?.childNode(withName: LabelIdentifier.timer.rawValue) as? SKLabelNode {
      timerNode.text = DateFormatterHelper.getMinuteSecondStyleText(time: time)
    }
    
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
  var pauseButton: ButtonNode!
  var timerNode: SKLabelNode!
}

extension GameSceneActiveState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    if previousState is GameSceneFailState {
      time = 0
    }
    
    pauseButton = createPauseButton()
    pauseButton.alpha = 0
    gameScene.camera?.addChild(pauseButton)
    pauseButton.fadeIn()
    
    if gameScene.camera?.childNode(withName: LabelIdentifier.timer.rawValue) == nil {
       timerNode = LabelBuilder.createTimerLabel()
      timerNode.position = GameSceneActiveState.getPosition(forTimerNode: timerNode, inScene: gameScene)
      gameScene.camera?.addChild(timerNode)
    }
    
    gameScene.listener = gameScene.entityManager.getPlayerRenderNode()
  }
  
  override func willExit(to nextState: GKState) {
    pauseButton?.removeFromParent()
    gameScene.listener = nil
  }
  
  func createPauseButton() -> ButtonNode {
    let pauseButton = ButtonBuilder.createButton(withIdentifier: .pause)
    pauseButton.anchorPoint = CGPoint(x: 1, y: 0)
    pauseButton.position = CGPoint(x: gameScene.size.width * 0.5, y: -gameScene.size.height * 0.5)
    return pauseButton
  }
  
  static func getPosition(forTimerNode timerNode: SKLabelNode, inScene scene: SKScene) -> CGPoint {
    var position = timerNode.position
    position.y = scene.size.height / 2 - timerNode.frame.size.height / 2
    return position
  }
}
