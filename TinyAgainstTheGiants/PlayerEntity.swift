//
//  PlayerEntity.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

class PlayerEntity: GKEntity {
  // MARK: Lifcycle
  init(node: SKSpriteNode) {
    super.init()
    
    let renderComponent = RenderComponent()
    let spriteComponent = SpriteComponent(node: node)
    guard let emitterNode = SKEmitterNode(fileNamed: "MagicParticle") else {
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
    
    addChargeBarComponentWithCharge(100, maxCharge: 100, toNode: renderComponent.node, withReferenceNode: spriteComponent.node)
    addTeamComponentWithTeam(.One)
    
    let radius = node.size.width / 2
    addPhysicsComponentWithRadius(radius, toNode: renderComponent.node)
    addMoveComponentWithRadius(Float(radius))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let maxSpeed: Float = 0
  let maxAcceleration: Float = 0
  let mass: Float = 1
  let damageCharge: Double = 5
}

// MARK: Component Functions
extension PlayerEntity {
  func addTeamComponentWithTeam(_ team: Team) {
    let teamComponent = TeamComponent(team: team)
    addComponent(teamComponent)
  }
  
  func addChargeBarComponentWithCharge(_ charge: Double, maxCharge: Double, toNode node: SKNode, withReferenceNode referenceNode: SKNode) {
    let xRange = SKRange(constantValue: 0)
    let yRange = SKRange(constantValue: 50)
    let constraint = SKConstraint.positionX(xRange, y: yRange)
    constraint.referenceNode = referenceNode
    
    let chargeBarComponent = ChargeBarComponent(charge: charge, maxCharge: maxCharge, displayChargeBar: true)
    chargeBarComponent.chargeBarNode?.constraints = [constraint]
    node.addChild(chargeBarComponent.chargeBarNode!)
    addComponent(chargeBarComponent)
  }
  
  func addMoveComponentWithRadius(_ radius: Float) {
    let moveComponent = MoveComponent(maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: radius, mass: mass)
    addComponent(moveComponent)
  }
  
  func addPhysicsComponentWithRadius(_ radius: CGFloat, toNode node: SKNode) {
    let physicsBody = SKPhysicsBody(circleOfRadius: radius)
    physicsBody.allowsRotation = false
    physicsBody.affectedByGravity = false
    
    let physicsComponent = PhysicsComponent(physicsBody: physicsBody)
    node.physicsBody = physicsComponent.physicsBody
    addComponent(physicsComponent)
  }
}

// MARK: ContactNotifiable
extension PlayerEntity: ContactNotifiable {
  func contactWithEntityDidBegin(_ entity: GKEntity) {
    guard let playerTeam = component(ofType: TeamComponent.self)?.team, let entityTeam = entity.component(ofType: TeamComponent.self)?.team else {
      return
    }
    
    if playerTeam != entityTeam {
      component(ofType: ChargeBarComponent.self)?.loseCharge(chargeToLose: damageCharge)
    }
  }
}
