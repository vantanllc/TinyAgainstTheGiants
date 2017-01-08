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
  init(node: SKSpriteNode, entityManager: EntityManager? = nil) {
    super.init()
    
    let renderComponent = RenderComponent()
    let spriteComponent = SpriteComponent(node: node)
    guard let emitterNode = SKEmitterNode(fileNamed: "FireParticle") else {
      print("Could not find Particle file!")
      return
    }
    let particleComponent = ParticleComponent(particleEffect: emitterNode)
    
    renderComponent.node.zPosition = NodeLayerPosition.entity
    renderComponent.node.addChild(spriteComponent.node)
    spriteComponent.node.addChild(particleComponent.particleEffect)
    
    addComponent(renderComponent)
    addComponent(spriteComponent)
    addComponent(particleComponent)
    
    let teamComponent = TeamComponent(team: .Two)
    addComponent(teamComponent)
    
    let physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
    physicsBody.allowsRotation = false
    physicsBody.affectedByGravity = false
    
    let physicsComponent = PhysicsComponent(physicsBody: physicsBody)
    renderComponent.node.physicsBody = physicsComponent.physicsBody
    addComponent(physicsComponent)
    
    let radius = Float(node.size.width * 0.5)
    let moveComponent = MoveComponent(maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: radius, mass: mass, entityManager: entityManager)
    addComponent(moveComponent)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let maxSpeed: Float = 200
  let maxAcceleration: Float = 100
  let mass: Float = 1
}
