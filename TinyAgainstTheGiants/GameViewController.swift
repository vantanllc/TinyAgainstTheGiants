//
//  GameViewController.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/30/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let size = CGSize(width: 1366, height: 1024)
    let gameScene = createGameScene(size: size)
    let skView = view as! SKView
    presentGameSceneInDevMode(gameScene: gameScene, intoSKView: skView)
  }
  
  // MARK: Config
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .allButUpsideDown
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}

// MARK: GameScene
extension GameViewController {
  func createGameScene(size: CGSize, scaleMode: SKSceneScaleMode = .resizeFill) -> GameScene {
    let gameScene = GameScene(size: size)
    gameScene.scaleMode = scaleMode
    return gameScene
  }
  
  func presentGameSceneInDevMode(gameScene: GameScene, intoSKView skView: SKView) {
    skView.presentScene(gameScene)
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.showsPhysics = true
  }
}



