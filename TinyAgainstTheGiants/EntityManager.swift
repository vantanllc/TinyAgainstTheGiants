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
  init(scene: SKScene) {
    self.scene = scene
  }
  
  // MARK: Properties
  let scene: SKScene
  var entities = Set<GKEntity>()
  var entitiesToRemove = Set<GKEntity>()
}

extension EntityManager {
  func add(entity: GKEntity) {
    entities.insert(entity)
    
    if let node = entity.component(ofType: RenderComponent.self)?.node {
      scene.addChild(node)
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
