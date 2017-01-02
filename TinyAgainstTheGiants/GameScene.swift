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
    
    worldNode = SKNode()
    addChild(worldNode)
    
    entityManager = EntityManager(scene: self)
    startCamera()
    addBackgroundTileMap()
    addObstacleTileMap()
    startNewGame()
    CameraBuilder.constraintCamera(camera!, toSpriteNode: entityManager.getPlayerSpriteNode()!)
  }
  
  override func didMove(to view: SKView) {
    CameraBuilder.constraintCamera(camera!, toTileMapEdges: currentBackgroundTileMap, inScene: self)
  }
  
  // MARK: Properties
  var entityManager: EntityManager!
  var currentBackgroundTileMap: SKTileMapNode!
  var currentObstacleTileMap: SKTileMapNode!
  
  // MARK: Nodes
  var worldNode: SKNode!
}

// MARK: Touches
extension GameScene {
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let touchLocation = touch.location(in: self.view)
      let previousTouchLocation = touch.previousLocation(in: self.view)
      
      if let playerNode = entityManager.getPlayerRenderNode() {
        let change = touchLocation - previousTouchLocation
        let changeNormalized = change.normalized()
        let vector = CGVector(dx: 30 * changeNormalized.x, dy: -30 * changeNormalized.y)
        playerNode.physicsBody?.applyForce(vector)
      }
    }
  }
}

// MARK: Game Setup Function
extension GameScene {
  func startNewGame() {
    EntityBuilder.addPlayer(position: TileMapBuilder.getRandomPositionNotOnTileGroupInTileMap(currentObstacleTileMap), toEntityManager: entityManager)
  }
  
  func startCamera() {
    let camera = SKCameraNode()
    CameraBuilder.addCamera(camera, toScene: self)
  }
  
  func addBackgroundTileMap() {
    guard let tileSet = SKTileSet(named: "Sand") else {
      return
    }
    currentBackgroundTileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: 42, rows: 32)
    worldNode.addChild(currentBackgroundTileMap)
  }
  
  func addObstacleTileMap() {
    guard let tileSet = SKTileSet(named: "Grass") else {
      return
    }
    
    let noiseMap = NoiseMapBuilder.getPerlinNoiseMap(frequency: 10)
    currentObstacleTileMap = TileMapBuilder.createTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: 42, rows: 32)
    worldNode.addChild(currentObstacleTileMap)
  }
}
