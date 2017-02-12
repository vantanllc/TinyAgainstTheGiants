//
//  TitleScreenState.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 2/11/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class TitleScreenState: GKState {
  // MARK: Lifecycle
  init(gameScene: GameScene) {
    self.gameScene = gameScene
    super.init()
  }

  // MARK: Properties
  unowned let gameScene: GameScene
}

extension TitleScreenState {
  override func didEnter(from previousState: GKState?) {
    super.didEnter(from: previousState)
    let startButton = ButtonBuilder.getStartButton()
    gameScene.camera?.addChild(startButton)
  }
  
  override func willExit(to nextState: GKState) {
    super.willExit(to: nextState)
    gameScene.camera?.childNode(withName: ButtonIdentifier.start.rawValue)?.removeFromParent()
  }
}
