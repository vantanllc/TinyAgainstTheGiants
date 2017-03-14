//
//  GameScene.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/30/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
  // MARK: Lifecycle
  override func sceneDidLoad() {
    super.sceneDidLoad()
    
    loadStateMachine()
    
    physicsWorld.contactDelegate = self
    
    worldNode = SKNode()
    addChild(worldNode)
    
    entityManager = EntityManager(scene: self)
    startCamera()
    addBackgroundTileMap()
    addObstacleTileMap()
  }
  
  override func didMove(to view: SKView) {
    stateMachine.enter(TitleScreenState.self)
    backgroundAudio = Sound.getBackgroundAudioPlayer()
    backgroundAudio.play()
    buttonAudio = Sound.getAudioPlayer(forResource: Sound.AudioFile.button, ofType: Sound.FileType.caf)
    buttonAudio.prepareToPlay()
  }
        
  override func didChangeSize(_ oldSize: CGSize) {
    super.didChangeSize(oldSize)
    let _ = LabelIdentifier.all.map { identifier in
      if let label = camera?.childNode(withName: identifier.rawValue) as? SKLabelNode {
        label.position = GameSceneActiveState.getPosition(forTimerNode: label, inScene: self)
      }
    }
    
    for button in [ButtonIdentifier.pause, ButtonIdentifier.credits] {
      camera?.childNode(withName: button.rawValue)?.position = CGPoint(x: size.width * 0.5, y: -size.height * 0.5)
    }
    
    if let title = camera?.childNode(withName: LabelIdentifier.title.rawValue) as? SKSpriteNode {
      if UIDevice.current.orientation == .portrait {
        title.anchorPoint = CGPoint(x: 0.5, y: 1)
        title.position = CGPoint(x: 0, y: size.height * 0.5)
      } else {
        title.anchorPoint = CGPoint(x: 0, y: 1)
        title.position = CGPoint(x: -size.width * 0.5, y: size.height * 0.5)
      }
    }
  }
  
  // MARK: Properties
  var entityManager: EntityManager!
  var stateMachine: GKStateMachine!
  weak var gameSceneDelegate: GameSceneDelegate?
  
  // MARK: TileMaps
  var previousBackgroundTileMap: SKTileMapNode!
  var currentBackgroundTileMap: SKTileMapNode!
  var nextBackgroundTileMap: SKTileMapNode!
  
  var previousObstacleTileMap: SKTileMapNode!
  var currentObstacleTileMap: SKTileMapNode!
  var nextObstacleTileMap: SKTileMapNode!
  
  var backgroundAudio: AVAudioPlayer!
  var buttonAudio: AVAudioPlayer!
  
  let tileMapColumns = 42
  let tileMapRows = 32
  
  // MARK: Nodes
  var worldNode: SKNode!
 
  // MARK: Timing
  var lastUpdateTime: TimeInterval = 0
  
  // MARK: Entities
  let maxEnemyCount: Int = 20
  let enemySpawnCoolDown: TimeInterval = 2
  var enemySpawnTime: TimeInterval = 2
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
    
    if let camera = camera, camera.position.y < currentBackgroundTileMap.frame.midY {
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

// MARK: Game Flow
extension GameScene {
  func loadStateMachine() {
    let states: [GKState] = [
      TitleScreenState(gameScene: self),
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
  
  func startNewGame() {
    addPlayer()
    camera?.constraints = nil
    CameraBuilder.constraintCamera(camera!, toSpriteNode: entityManager.getPlayerSpriteNode()!)
    CameraBuilder.constraintCamera(camera!, toTileMapEdges: previousBackgroundTileMap, inScene: self)
  }
  
  func startCamera() {
    let camera = SKCameraNode()
    CameraBuilder.addCamera(camera, toScene: self)
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
  
  func addPlayer() {
    EntityBuilder.addPlayer(position: TileMapBuilder.getRandomPositionNotOnTileGroupInTileMap(currentObstacleTileMap), toEntityManager: entityManager)
  }
}

// MARK: Configuration
extension GameScene {
  struct Configuration {
    static let gravity = CGVector(dx: 0, dy: -1)
  }
}
