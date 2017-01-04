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
  var previousBackgroundTileMap: SKTileMapNode!
  var currentBackgroundTileMap: SKTileMapNode!
  var nextBackgroundTileMap: SKTileMapNode!
  
  var previousObstacleTileMap: SKTileMapNode!
  var currentObstacleTileMap: SKTileMapNode!
  var nextObstacleTileMap: SKTileMapNode!
  
  let tileMapColumns = 42
  let tileMapRows = 32
  
  // MARK: Nodes
  var worldNode: SKNode!
}

// MARK: Update
extension GameScene {
  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    
    if let camera = camera, !camera.contains(currentBackgroundTileMap), camera.position.y < currentBackgroundTileMap.frame.maxY {
      updateBackgroundTileMaps()
      updateObstacleTileMaps()
    }
  }
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
    
    currentBackgroundTileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: tileMapColumns, rows: tileMapRows)
    worldNode.addChild(currentBackgroundTileMap)
    previousBackgroundTileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: tileMapColumns, rows: tileMapRows)
    previousBackgroundTileMap.position.x = currentBackgroundTileMap.frame.minX
    previousBackgroundTileMap.position.y = previousBackgroundTileMap.mapSize.height + currentBackgroundTileMap.frame.maxY
    worldNode.addChild(previousBackgroundTileMap)
    addNextBackgroundTileMap()
  }
  
  func addNextBackgroundTileMap() {
    guard let tileSet = SKTileSet(named: "Sand") else {
      return
    }
    nextBackgroundTileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: tileMapColumns, rows: tileMapRows)
    nextBackgroundTileMap.position.x = currentBackgroundTileMap.frame.minX
    nextBackgroundTileMap.position.y = currentBackgroundTileMap.frame.minY
    worldNode.addChild(nextBackgroundTileMap)
  }
  
  func addObstacleTileMap() {
    guard let tileSet = SKTileSet(named: "Grass") else {
      return
    }
    
    let noiseMap = NoiseMapBuilder.getPerlinNoiseMap(frequency: 10)
    currentObstacleTileMap = TileMapBuilder.createCappedTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: tileMapColumns, rows: tileMapRows)
    worldNode.addChild(currentObstacleTileMap)
    previousObstacleTileMap = TileMapBuilder.createEdgedTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: tileMapColumns, rows: tileMapRows)
    previousObstacleTileMap.position.x = currentObstacleTileMap.frame.minX
    previousObstacleTileMap.position.y = previousObstacleTileMap.mapSize.height + currentObstacleTileMap.frame.maxY
    worldNode.addChild(previousObstacleTileMap)
    addNextObstacleTileMap()
  }
  
  func addNextObstacleTileMap() {
    guard let tileSet = SKTileSet(named: "Grass") else {
      return
    }
    let noiseMap = NoiseMapBuilder.getPerlinNoiseMap(frequency: 10)
    nextObstacleTileMap = TileMapBuilder.createEdgedTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: tileMapColumns, rows: tileMapRows)
    nextObstacleTileMap.position.x = currentObstacleTileMap.frame.minX
    nextObstacleTileMap.position.y = currentObstacleTileMap.frame.minY
    worldNode.addChild(nextObstacleTileMap)
  }
  
  func updateBackgroundTileMaps() {
    if let tileMap = previousBackgroundTileMap, tileMap.parent != nil {
      tileMap.removeFromParent()
    }
    
    previousBackgroundTileMap = currentBackgroundTileMap
    currentBackgroundTileMap = nextBackgroundTileMap
    addNextBackgroundTileMap()
  }
  
  func updateObstacleTileMaps() {
    if let tileMap = previousObstacleTileMap, tileMap.parent != nil {
      tileMap.removeFromParent()
    }
    
    previousObstacleTileMap = currentObstacleTileMap
    TileMapBuilder.addTopEdgeToTileMap(previousObstacleTileMap)
    
    currentObstacleTileMap = nextObstacleTileMap
    addNextObstacleTileMap()
  }
}
