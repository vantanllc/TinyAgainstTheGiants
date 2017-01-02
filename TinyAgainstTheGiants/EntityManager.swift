//
//  EntityManager.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

class EntityManager {
  // MARK Functions
  func update(deltaTime: TimeInterval) {
    entitiesToRemove.removeAll()
  }
  
  // MARK: Lifecycle
  init(scene: GameScene) {
    self.scene = scene
  }
  
  // MARK: Properties
  let scene: GameScene
  var entities = Set<GKEntity>()
  var entitiesToRemove = Set<GKEntity>()
}

// MARK: Player Functions
extension EntityManager {
  func getPlayerSpriteNode() -> SKSpriteNode? {
    let playerEntity = getPlayerEntity()
    return playerEntity?.component(ofType: SpriteComponent.self)?.node
  }
  
  func getPlayerEntity() -> GKEntity? {
    return entities.filter { entity in return entity.isKind(of: PlayerEntity.self)}.first
  }
  
  func getPlayerRenderNode() -> SKNode? {
    let playerEntity = getPlayerEntity()
    return playerEntity?.component(ofType: RenderComponent.self)?.node
  }
}

// MARK: Collection Functions
extension EntityManager {
  func add(entity: GKEntity) {
    entities.insert(entity)
    
    if let node = entity.component(ofType: RenderComponent.self)?.node {
      scene.worldNode.addChild(node)
    }
  }
  
  func remove(entity: GKEntity) {
    entities.remove(entity)
    entitiesToRemove.insert(entity)
    
    if let node = entity.component(ofType: RenderComponent.self)?.node {
      node.removeFromParent()
    }
  }
}
