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
    for entity in entitiesToRemove {
      for componentSystem in componentSystems {
        componentSystem.removeComponent(foundIn: entity)
      }
    }
    
    for componentSystem in componentSystems {
      componentSystem.update(deltaTime: deltaTime)
    }
    
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
  var componentSystems: [GKComponentSystem<GKComponent>] = [
    GKComponentSystem(componentClass: MoveComponent.self)
  ]
}

// MARK: Enemy Functions
extension EntityManager {
  func getEnemyEntities() -> [GKEntity]? {
    return entities.filter { entity in return entity.isKind(of: EnemyEntity.self)}
  }
}

// MARK: Behavior Functions
extension EntityManager {
  func getEntitiesForTeam(_ team: Team) -> [GKEntity] {
    let entitiesOfTeam = entities.filter { entity in
      return entity.component(ofType: TeamComponent.self)?.team == team
    }
    
    return entitiesOfTeam
  }
  
  func getMoveComponentsForTeam(_ team: Team) -> [MoveComponent] {
    let entitiesOfTeam = getEntitiesForTeam(team)
    
    let moveComponents = entitiesOfTeam.flatMap { entity in
      return entity.component(ofType: MoveComponent.self)
    }
    
    return moveComponents
  }
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
    
    for componentSystem in componentSystems {
      componentSystem.addComponent(foundIn: entity)
    }
  }
  
  func remove(entity: GKEntity) {
    entities.remove(entity)
    entitiesToRemove.insert(entity)
    
    if let node = entity.component(ofType: RenderComponent.self)?.node {
      node.removeFromParent()
    }
  }
  
  func removeAll() {
    for entity in entities {
      remove(entity: entity)
    }
  }
}
