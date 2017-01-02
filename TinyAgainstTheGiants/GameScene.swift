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
  
  func constraintCameraToPlayer() {
    guard let camera = camera, let player = entityManager.getPlayerSpriteNode() else {
      return
    }
    
    let constraint = CameraBuilder.createCameraConstraintToCenterOnSpriteNode(player)
    CameraBuilder.addContraints([constraint], toCamera: camera)
  }
  
  func constraintCamera(_ camera: SKCameraNode, toTileMapEdges tileMap: SKTileMapNode, inScene scene: SKScene, withInset inset: CGFloat = 100) {
    let scaledSize = CGSize(width: scene.size.width * camera.xScale, height: scene.size.height * camera.yScale)
    let xLowerLimit = scaledSize.width / 2 - inset
    let xUpperLimit = tileMap.mapSize.width - scaledSize.width / 2 + inset
    let xRange = SKRange(lowerLimit: xLowerLimit, upperLimit: xUpperLimit)
    
    let yUpperLimit = -scaledSize.height / 2 + inset
    let yRange = SKRange(upperLimit: yUpperLimit)
    let edgeContraint = SKConstraint.positionX(xRange, y: yRange)
    
    CameraBuilder.addContraints([edgeContraint], toCamera: camera)
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
