//
//  GameScene.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/30/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  // MARK: Lifecycle
  override func sceneDidLoad() {
    super.sceneDidLoad()
    
    entityManager = EntityManager(scene: self)
    startCamera()
    startNewGame()
    constraintCameraToPlayer()
  }
  
  // MARK: Properties
  var entityManager: EntityManager!
}

// MARK: Game Setup Function
extension GameScene {
  func startNewGame() {
    EntityBuilder.addPlayer(position: CGPoint.zero, toEntityManager: entityManager)
  }
  
  func startCamera() {
    let camera = SKCameraNode()
    CameraBuilder.addCamera(camera, toScene: self)
  }
  
  func constraintCameraToPlayer() {
    guard let camera = camera, let player = entityManager.getPlayerSpriteNode() else {
      return
    }
    
    let constraint = CameraBuilder.createCameraConstraintToCenterOnSpriteNode(player)
    CameraBuilder.addContraints([constraint], toCamera: camera)
  }
}
