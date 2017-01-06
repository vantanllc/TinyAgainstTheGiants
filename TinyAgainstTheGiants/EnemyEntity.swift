//
//  EnemyEntity.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/5/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class EnemyEntity: GKEntity {
  // MARK: Lifcycle
  init(node: SKSpriteNode) {
    super.init()
    
    let renderComponent = RenderComponent()
    renderComponent.node.zPosition = NodeLayerPosition.entity
    addComponent(renderComponent)
    
    let spriteComponent = SpriteComponent(node: node)
    addComponent(spriteComponent)
    
    renderComponent.node.addChild(spriteComponent.node)
    
    let teamComponent = TeamComponent(team: .Two)
    addComponent(teamComponent)
    
    let physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
    physicsBody.allowsRotation = false
    physicsBody.affectedByGravity = false
    
    let physicsComponent = PhysicsComponent(physicsBody: physicsBody)
    renderComponent.node.physicsBody = physicsComponent.physicsBody
    addComponent(physicsComponent)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
