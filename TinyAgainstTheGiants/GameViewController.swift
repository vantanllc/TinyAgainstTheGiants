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
import GoogleMobileAds

class GameViewController: UIViewController {
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    interstitial = AdBuilder.getInterstitial(withDelegate: self)
    
    let size = CGSize(width: 1366, height: 1024)
    gameScene = createGameScene(size: size, withDelegate: self)
    if let skView = view as? SKView {
      presentGameSceneInDevMode(gameScene: gameScene, intoSKView: skView)
    }
  }
  
  override func viewDidLayoutSubviews() {
    if gameScene.size != view.bounds.size {
      gameScene.size = view.bounds.size
    }
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
  
  // MARK: Properties
  var gameScene: GameScene!
  var interstitial: GADInterstitial!
}

// MARK: GameScene
extension GameViewController {
  func createGameScene(size: CGSize, withDelegate delegate: GameSceneDelegate? = nil, scaleMode: SKSceneScaleMode = .resizeFill) -> GameScene {
    let gameScene = GameScene(size: size)
    gameScene.scaleMode = scaleMode
    gameScene.gameSceneDelegate = delegate
    return gameScene
  }
  
  func presentGameSceneInDevMode(gameScene: GameScene, intoSKView skView: SKView) {
    skView.presentScene(gameScene)
    skView.ignoresSiblingOrder = true
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.showsPhysics = true
  }
}
