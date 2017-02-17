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
    
    if let enemies = gameScene.entityManager.getEnemyEntities(), enemies.count < gameScene.maxEnemyCount, gameScene.enemySpawnTime.isLessThanOrEqualTo(0) {
      gameScene.addEnemy()
      gameScene.enemySpawnTime = gameScene.enemySpawnCoolDown
    }
    
    time += seconds
    if let timerNode = gameScene.camera?.childNode(withName: LabelIdentifier.timer.rawValue) as? SKLabelNode {
      timerNode.text = timeString
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
    gameScene.camera?.addChild(createPauseButton())
    
    if gameScene.camera?.childNode(withName: LabelIdentifier.timer.rawValue) == nil {
      let timerNode = createTimerNode()
      timerNode.position = GameSceneActiveState.getPosition(forTimerNode: timerNode, inScene: gameScene)
      gameScene.camera?.addChild(timerNode)
    }
  }
  
  override func willExit(to nextState: GKState) {
    gameScene.camera?.childNode(withName: ButtonIdentifier.pause.rawValue)?.removeFromParent()
  }
  
  func createPauseButton() -> ButtonNode {
    let pauseButton = ButtonBuilder.getPauseButton()
    pauseButton.zPosition = NodeLayerPosition.button
    pauseButton.anchorPoint = CGPoint(x: 1, y: 0)
    pauseButton.position = CGPoint(x: gameScene.size.width * 0.5, y: -gameScene.size.height * 0.5)
    return pauseButton
  }
  
  func createTimerNode() -> SKLabelNode {
    let timerNode = SKLabelNode()
    timerNode.fontName = GameSceneActiveState.Configuration.timerLabelFont
    timerNode.name = LabelIdentifier.timer.rawValue
    timerNode.zPosition = NodeLayerPosition.label
    timerNode.horizontalAlignmentMode = .center
    timerNode.verticalAlignmentMode = .top
    timerNode.fontSize = 50
    return timerNode
  }
  
  static func getPosition(forTimerNode timerNode: SKLabelNode, inScene scene: SKScene) -> CGPoint {
    var position = timerNode.position
    position.y = scene.size.height / 2 - timerNode.frame.size.height / 2
    return position
  }
}

extension GameSceneActiveState {
  struct Configuration {
    static let timerLabelFont = "AmericanTypewriter-Bold"
  }
}
