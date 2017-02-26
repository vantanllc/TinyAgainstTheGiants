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
      let bestTimeText = getBestTimeText(time: activeState.time, fromUserDefaults: UserDefaults.standard)
      bestTimeNode = LabelBuilder.createTimerLabel()
      bestTimeNode.text = bestTimeText
      bestTimeNode.fontSize = Configuration.bestTimeLabelFontSize
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
  func getBestTimeText(time: TimeInterval, fromUserDefaults userDefaults: UserDefaults) -> String {
    let previousBestTime = userDefaults.double(forKey: Configuration.bestTimeKey)
    var text = "Best Time \(DateFormatterHelper.getMinuteSecondStyleText(time: previousBestTime))"
  
    if time > previousBestTime {
      text = "New best time \(DateFormatterHelper.getMinuteSecondStyleText(time: time))"
      userDefaults.set(time, forKey: Configuration.bestTimeKey)
      userDefaults.synchronize()
    }
  
    return text
  }
}

extension GameSceneFailState {
  struct Configuration {
    static let bestTimeKey = "bestTime"
    static let bestTimeLabelFontSize: CGFloat = 20
  }
}
