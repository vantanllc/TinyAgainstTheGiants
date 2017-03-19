//
//  GameScene+TileMapNode.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/17/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

extension GameScene {
  struct TileSet {
    static let background = "Sand"
    static let obstacle = "Obstacles"
  }
  func addBackgroundTileMap() {
    guard let tileSet = SKTileSet(named: TileSet.background) else {
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
    guard let tileSet = SKTileSet(named: TileSet.background) else {
      return
    }
    
    DispatchQueue.global(qos: .userInitiated).async {
      if let tileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: self.tileMapColumns, rows: self.tileMapRows) {
        DispatchQueue.main.async {
          tileMap.position.x = self.currentBackgroundTileMap.frame.minX
          tileMap.position.y = self.currentBackgroundTileMap.frame.minY
          self.nextBackgroundTileMap = tileMap
          self.worldNode.addChild(self.nextBackgroundTileMap)
        }
      }
    }
  }
  
  func configureTileMap(_ tileMap: SKTileMapNode) {
    tileMap.zPosition = NodeLayerPosition.obstacle
    tileMap.physicsBody = SKPhysicsBody(bodies: TileMapPhysicsBuilder.getPhysicsBodiesFromTileMapNode(tileMapNode: tileMap))
    tileMap.physicsBody?.categoryBitMask = ColliderType.Obstacle.categoryMask
    tileMap.physicsBody?.isDynamic = false
    tileMap.physicsBody?.affectedByGravity = false
  }
  
  func createCappedObstacleTileMapWithTileSet(_ tileSet: SKTileSet) -> SKTileMapNode? {
    let noiseMap = NoiseMapBuilder.getPerlinNoiseMap(frequency: 10)
    
    if let tileMap = TileMapBuilder.createCappedTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: tileMapColumns, rows: tileMapRows) {
      configureTileMap(tileMap)
      return tileMap
    } else {
      return nil
    }
  }
  
  func createObstacleTileMapWithTileSet(_ tileSet: SKTileSet) -> SKTileMapNode? {
    let noiseMap = NoiseMapBuilder.getPerlinNoiseMap(frequency: 10)
    if let tileMap = TileMapBuilder.createEdgedTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: tileMapColumns, rows: tileMapRows) {
      configureTileMap(tileMap)
      return tileMap
    } else {
      return nil
    }
  }
  
  func addObstacleTileMap() {
    guard let tileSet = SKTileSet(named: TileSet.obstacle) else {
      return
    }
    
    currentObstacleTileMap = createCappedObstacleTileMapWithTileSet(tileSet)
    worldNode.addChild(currentObstacleTileMap)
    
    previousObstacleTileMap = createCappedObstacleTileMapWithTileSet(tileSet)
    previousObstacleTileMap.position.x = currentObstacleTileMap.frame.minX
    previousObstacleTileMap.position.y = previousObstacleTileMap.mapSize.height + currentObstacleTileMap.frame.maxY
    worldNode.addChild(previousObstacleTileMap)
    addNextObstacleTileMap()
  }
  
  func addNextObstacleTileMap() {
    guard let tileSet = SKTileSet(named: TileSet.obstacle) else {
      return
    }
    nextObstacleTileMap = createObstacleTileMapWithTileSet(tileSet)
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
    previousObstacleTileMap.physicsBody = SKPhysicsBody(bodies: TileMapPhysicsBuilder.getPhysicsBodiesFromTileMapNode(tileMapNode: previousObstacleTileMap))
    
    currentObstacleTileMap = nextObstacleTileMap
    addNextObstacleTileMap()
  }
}
