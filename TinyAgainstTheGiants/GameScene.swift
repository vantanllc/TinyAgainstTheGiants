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
    
    initializeGameStateMachine()
    
    physicsWorld.contactDelegate = self
    
    worldNode = SKNode()
    addChild(worldNode)
    
    entityManager = EntityManager(scene: self)
    startCamera()
    addBackgroundTileMap()
    addObstacleTileMap()
  }
  
  override func didMove(to view: SKView) {
    startNewGame()
    addTimerNodeToCamera(camera!)
    addPauseButtonToCamera(camera!)
  }
        
  override func didChangeSize(_ oldSize: CGSize) {
    super.didChangeSize(oldSize)
    if let timerNode = timerNode {
      timerNode.position = getPositionForTimerNode(timerNode)
    }
    if let button = pauseButton {
      button.position = getPositionForPauseButton()
    }
  }
  
  // MARK: Properties
  var entityManager: EntityManager!
  var stateMachine: GKStateMachine!
  
  // MARK: TileMaps
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
  var timerNode: SKLabelNode!
  var pauseButton: ButtonNode!
 
  // MARK: Timing
  var lastUpdateTime: TimeInterval = 0
  
  // MARK: Entities
  let maxEnemyCount: Int = 10
  let enemySpawnCoolDown: TimeInterval = 5
  var enemySpawnTime: TimeInterval = 5
}

// MARK: Update
extension GameScene {
  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    
    if lastUpdateTime.isZero {
      lastUpdateTime = currentTime
    }
    
    let deltaTime = currentTime - lastUpdateTime
    lastUpdateTime = currentTime
    
    stateMachine.update(deltaTime: deltaTime)
    
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

// MARK: Displays
extension GameScene {
  func addTimerNodeToCamera(_ camera: SKCameraNode) {
    timerNode = SKLabelNode()
    timerNode.zPosition = NodeLayerPosition.label
    timerNode.horizontalAlignmentMode = .center
    timerNode.verticalAlignmentMode = .top
    timerNode.fontSize = 50
    timerNode.position = getPositionForTimerNode(timerNode)
    camera.addChild(timerNode)
  }
  
  func addPauseButtonToCamera(_ camera: SKCameraNode) {
    pauseButton = ButtonBuilder.getPauseButton()
    pauseButton.zPosition = NodeLayerPosition.button
    pauseButton.anchorPoint = CGPoint(x: 1, y: 0)
    pauseButton.position = getPositionForPauseButton()
    camera.addChild(pauseButton)  
  }
  
  func getPositionForPauseButton() -> CGPoint {
    return CGPoint(x: size.width * 0.5, y: -size.height * 0.5)
  }
  
  func getPositionForTimerNode(_ timerNode: SKLabelNode) -> CGPoint {
    var position = timerNode.position
    position.y = size.height / 2 - timerNode.frame.size.height / 2
    return position
  }
}

// MARK: Game Flow
extension GameScene {
  func initializeGameStateMachine() {
    let states: [GKState] = [
      GameSceneActiveState(gameScene: self),
      GameSceneFailState(gameScene: self),
      GameScenePauseState(gameScene: self)
    ]
    stateMachine = GKStateMachine(states: states)
  }
  
  func pause() {
    worldNode.isPaused = true
    physicsWorld.speed = 0
  }
  
  func resume() {
    worldNode.isPaused = false
    physicsWorld.speed = 1.0
  }
}

// MARK: Physics Contact
extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    handleContact(contact: contact) {contactNotifiable, otherEntity in
      contactNotifiable.contactWithEntityDidBegin?(otherEntity)
    }
  }
  
  func didEnd(_ contact: SKPhysicsContact) {
    handleContact(contact: contact) {contactNotifiable, otherEntity in
      contactNotifiable.contactWithEntityDidEnd?(otherEntity)
    }
  }
  
}

// MARK: Adding Entities
extension GameScene {
  func addEnemy() {
    EntityBuilder.addEnemy(position: TileMapBuilder.getRandomPositionInTileMap(currentObstacleTileMap), toEntityManager: entityManager)
  }
}

// MARK: Game Setup Function
extension GameScene {
  func startNewGame() {
    EntityBuilder.addPlayer(position: TileMapBuilder.getRandomPositionNotOnTileGroupInTileMap(currentObstacleTileMap), toEntityManager: entityManager)
    camera?.constraints = nil
    CameraBuilder.constraintCamera(camera!, toSpriteNode: entityManager.getPlayerSpriteNode()!)
    CameraBuilder.constraintCamera(camera!, toTileMapEdges: previousBackgroundTileMap, inScene: self)
    stateMachine.enter(GameSceneActiveState.self)
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
    guard let tileSet = SKTileSet(named: "Grass") else {
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
    guard let tileSet = SKTileSet(named: "Grass") else {
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
