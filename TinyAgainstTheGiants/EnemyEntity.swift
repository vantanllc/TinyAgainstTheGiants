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
    
    addTeamComponentWithTeam(.Two)
    let radius = node.size.width / 2
    addPhysicsComponentWithRadius(radius, toNode: renderComponent.node)
    addMoveComponentWithRadius(Float(radius), andEntityManager: entityManager)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let maxSpeed: Float = 200
  let maxAcceleration: Float = 100
  let mass: Float = 1
}

// MARK: Component Functions
private extension EnemyEntity {
  func addTeamComponentWithTeam(_ team: Team) {
    let teamComponent = TeamComponent(team: team)
    addComponent(teamComponent)
  }
  
  func addMoveComponentWithRadius(_ radius: Float, andEntityManager entityManager: EntityManager?) {
    let moveComponent = MoveComponent(maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: radius, mass: mass, entityManager: entityManager)
    addComponent(moveComponent)
  }
  
  func addPhysicsComponentWithRadius(_ radius: CGFloat, toNode node: SKNode) {
    let physicsBody = SKPhysicsBody(circleOfRadius: radius)
    physicsBody.allowsRotation = false
    physicsBody.affectedByGravity = false
    
    let colliderType = ColliderType.Enemy
    ColliderType.definedCollisions[.Enemy] = [.Player, .Enemy]
    let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: colliderType)
    node.physicsBody = physicsComponent.physicsBody
    addComponent(physicsComponent)
  }
}
