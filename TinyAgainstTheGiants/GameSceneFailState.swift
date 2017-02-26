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
  var bestTimeNode: SKLabelNode!
}

extension GameSceneFailState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    
    if let renderNode = gameScene.entityManager.getPlayerRenderNode() {
      retryButton = ButtonBuilder.createButton(withIdentifier: .retry)
      retryButton.position = renderNode.position.applying(CGAffineTransform(translationX: 0, y: 100))
      gameScene.addChild(retryButton)
    }
    
    if let activeState = previousState as? GameSceneActiveState {
      let previousBestTime = UserDefaults.standard.double(forKey: Configuration.bestTimeKey)
      var components = DateComponents()
      components.second = Int(previousBestTime)
      let previousBestTimeString = DateFormatterHelper.minuteSecondFormat.string(from: components)!
      bestTimeNode = LabelBuilder.createTimerLabel()
      bestTimeNode.fontSize = 20
      bestTimeNode.text = "Best Time \(previousBestTimeString)"
      
      if activeState.time > previousBestTime {
        bestTimeNode.text = "New best time \(activeState.timeString)"
        UserDefaults.standard.set(activeState.time, forKey: Configuration.bestTimeKey)
        UserDefaults.standard.synchronize()
      }
      
      bestTimeNode.position = activeState.timerNode.position.applying(CGAffineTransform.init(translationX: 0, y: -activeState.timerNode.frame.size.height))
      gameScene.camera?.addChild(bestTimeNode)
    }
    
    gameScene.pause()
    gameScene.gameSceneDelegate?.didEnteredFailState()
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    retryButton?.removeFromParent()
    bestTimeNode?.removeFromParent()
    gameScene.resume()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass is GameSceneActiveState.Type
  }
}

extension GameSceneFailState {
  struct Configuration {
    static let bestTimeKey = "bestTime"
  }
}
