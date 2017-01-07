//
//  EntityBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/1/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class EntityBuilder {
  // MARK: Functions
  static func addPlayer(position: CGPoint, toEntityManager entityManager: EntityManager) {
    let node = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 40))
    let entity = PlayerEntity(node: node)
    
    if let renderNode = entity.component(ofType: RenderComponent.self)?.node {
      renderNode.position = position
    }
    
    entityManager.add(entity: entity)
  }
  static func addEnemy(position: CGPoint, toEntityManager entityManager: EntityManager) {
    let node = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))
    let entity = EnemyEntity(node: node)
    
    if let renderNode = entity.component(ofType: RenderComponent.self)?.node {
      renderNode.position = position
    }
    
    entityManager.add(entity: entity)
  }
  
}
