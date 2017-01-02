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
    addBackgroundTileMap()
    addObstacleTileMap()
    startNewGame()
    constraintCameraToPlayer()
  }
  
  // MARK: Properties
  var entityManager: EntityManager!
  var currentBackgroundTileMap: SKTileMapNode!
  var currentObstacleTileMap: SKTileMapNode!
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
  
  func addBackgroundTileMap() {
    guard let tileSet = SKTileSet(named: "Sand") else {
      return
    }
    currentBackgroundTileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: 42, rows: 32)
    addChild(currentBackgroundTileMap)
  }
  
  func addObstacleTileMap() {
    guard let tileSet = SKTileSet(named: "Grass") else {
      return
    }
    
    let noiseMap = NoiseMapBuilder.getPerlinNoiseMap(frequency: 10)
    currentObstacleTileMap = TileMapBuilder.createTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: 42, rows: 32)
    addChild(currentObstacleTileMap)
  }
}
