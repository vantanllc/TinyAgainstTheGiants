//
//  PlayerEntityTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class PlayerEntitySpec: QuickSpec {
  override func spec() {
    var player: PlayerEntity!
    var spriteNode: SKSpriteNode!
    
    describe("PlayerEntity") {
      beforeEach {
        spriteNode = SKSpriteNode(color: .blue, size: CGSize(width: 10, height: 20))
        player = PlayerEntity(node: spriteNode)
      }
      
      afterEach {
        ColliderType.definedCollisions.removeAll()
        ColliderType.requestedContactNotifications.removeAll()
      }
      
      it("should have a TeamComponent with Team.One") {
        let team = player.component(ofType: TeamComponent.self)?.team
        expect(team).to(equal(Team.One))
      }
      
      describe("PhysicsComponent") {
        it("should have a PhysicsComponent") {
          let physicsComponent = player.component(ofType: PhysicsComponent.self)
          expect(physicsComponent).toNot(beNil())
        }
        
        it("should update ColliderType.definedCollisions") {
          let expectedDefinedCollisions: [ColliderType: [ColliderType]] = [.Player: [.Player, .Obstacle, .Enemy]]
          expect(ColliderType.definedCollisions[.Player]).to(equal(expectedDefinedCollisions[.Player]))
        }
        
        it("should update ColliderType.requestedContactNotifications") {
          let expectedContacts: [ColliderType: [ColliderType]] = [.Player: [.Enemy]]
          expect(ColliderType.requestedContactNotifications[.Player]).to(equal(expectedContacts[.Player]))
        }
      }
      describe("RenderComponent") {
        var renderComponent: RenderComponent!
        beforeEach {
          renderComponent = player.component(ofType: RenderComponent.self)
        }
        
        it("should have a RenderComponent") {
          expect(renderComponent).toNot(beNil())
        }
        
        it("should set node zPosition to NodeLayerPosition.entity") {
          expect(renderComponent.node.zPosition).to(equal(NodeLayerPosition.entity))
        }
      }
      
      describe("SpriteComponent") {
        var spriteComponent: SpriteComponent!
        
        beforeEach {
          spriteComponent = player.component(ofType: SpriteComponent.self)
        }
        
        it("should have SpriteComponent") {
          expect(spriteComponent).toNot(beNil())
        }
        
        it("should add SpriteComponent.node as a child of RenderComponent.node") {
          let renderComponent: RenderComponent! = player.component(ofType: RenderComponent.self)
          expect(renderComponent.node.children).to(contain(spriteNode))
        }
      }
      
      describe("ParticleComponent") {
        var particleComponent: ParticleComponent!
        
        beforeEach {
          particleComponent = player.component(ofType: ParticleComponent.self)
        }
        
        it("should have ParticleComponent") {
          expect(particleComponent).toNot(beNil())
        }
        
        it("should add emitter node as a child of SpriteComponent.node") {
          let emitterNode: SKEmitterNode! = player.component(ofType: ParticleComponent.self)?.particleEffect
          expect(spriteNode.children).to(contain(emitterNode))
        }
      }
      
      describe("ChargeBarComponent") {
        var chargeBarComponent: ChargeBarComponent!
        
        beforeEach {
          chargeBarComponent = player.component(ofType: ChargeBarComponent.self)
        }
        
        it("should have ChargeBarComponent") {
          expect(chargeBarComponent).toNot(beNil())
        }
        
        it("RenderComponent.node should contain ChargeBarComponent.chargeBarNode") {
          let renderNode = player.component(ofType: RenderComponent.self)?.node
          let chargeBarNode = chargeBarComponent.chargeBarNode
          expect(renderNode?.children).to(contain(chargeBarNode!))
        }
        
        it("ChargeBarComponent.chargeBarNode should have distance constraint") {
          expect(chargeBarComponent.chargeBarNode?.constraints).to(haveCount(1))
        }
      }
      
      describe("MoveComponent") {
        var moveComponent: MoveComponent!
        
        beforeEach {
          moveComponent = player.component(ofType: MoveComponent.self)
        }
        
        it("should have MoveComponent") {
          expect(moveComponent).toNot(beNil())
        }
        
        it("should set maxSpeed to entity defined maxSpeed") {
          expect(moveComponent.maxSpeed).to(equal(player.maxSpeed))
        }
        
        it("should set maxAcceleration to entity defined maxAcceleration") {
          expect(moveComponent.maxAcceleration).to(equal(player.maxAcceleration))
        }
        
        it("should set radius to half of spriteNode width") {
          let expectedRadius = Float(spriteNode.size.width * 0.5)
          expect(moveComponent.radius).to(equal(expectedRadius))
        }
        
        it("should set mass to entity defined mass") {
          expect(moveComponent.mass).to(equal(player.mass))
        }
        
        it("should not have a reference to entityManager")   {
          expect(moveComponent.entityManager).to(beNil())
        }
      }
      
      describe("Contactifiable") {
        it("should conform to protocol") {
          expect(player.conforms(to: ContactNotifiable.self)).to(beTrue())
        }
        
        context("contact with opposite team entity") {
          it("should lose defined amount of damageCharge") {
            let chargeBar = player.component(ofType: ChargeBarComponent.self)!
            let expectedCharge = chargeBar.charge - player.damageCharge
            let enemyEntity = EnemyEntity(node: SKSpriteNode())
            player.contactWithEntityDidBegin(enemyEntity)
            expect(chargeBar.charge).to(equal(expectedCharge))
          }
        }
      }
    }
  }
}
