//
//  EnemyEntityTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/5/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class EnemyEntitySpec: QuickSpec {
  override func spec() {
    var enemy: EnemyEntity!
    var spriteNode: SKSpriteNode!
    
    describe("EnemyEntity") {
      beforeEach {
        spriteNode = SKSpriteNode(color: .blue, size: CGSize(width: 10, height: 20))
        enemy = EnemyEntity(node: spriteNode)
      }
      
      it("should have a TeamComponent with Team.Two") {
        let team = enemy.component(ofType: TeamComponent.self)?.team
        expect(team).to(equal(Team.Two))
      }
      
      describe("PhysicsComponent") {
        it("should have a PhysicsComponent") {
          let physicsComponent = enemy.component(ofType: PhysicsComponent.self)
          expect(physicsComponent).toNot(beNil())
        }
          
        it("should update ColliderType.definedCollisions") {
          let expectedDefinedCollisions: [ColliderType: [ColliderType]] = [.Enemy: [.Player, .Enemy]]
          expect(ColliderType.definedCollisions[.Enemy]).to(equal(expectedDefinedCollisions[.Enemy]))
        }
      }
      
      describe("RenderComponent") {
        var renderComponent: RenderComponent!
        beforeEach {
          renderComponent = enemy.component(ofType: RenderComponent.self)
        }
        
        it("should have a RenderComponent") {
          expect(renderComponent).toNot(beNil())
        }
        
        it("should set node zPosition to NodeLayerPosition.entity") {
          expect(renderComponent.node.zPosition).to(equal(NodeLayerPosition.entity))
        }
      }
    }
    
    describe("SpriteComponent") {
      var spriteComponent: SpriteComponent!
      
      beforeEach {
        spriteComponent = enemy.component(ofType: SpriteComponent.self)
      }
      
      it("should have SpriteComponent") {
        expect(spriteComponent).toNot(beNil())
      }
      
      it("should add SpriteComponent.node as a child of RenderComponent.node") {
        let renderComponent: RenderComponent! = enemy.component(ofType: RenderComponent.self)
        expect(renderComponent.node.children).to(contain(spriteNode))
      }
    }
    
    describe("ParticleComponent") {
      var particleComponent: ParticleComponent!
      
      beforeEach {
        particleComponent = enemy.component(ofType: ParticleComponent.self)
      }
      
      it("should have ParticleComponent") {
        expect(particleComponent).toNot(beNil())
      }
      
      it("should add emitter node as a child of SpriteComponent.node") {
        let emitterNode: SKEmitterNode! = enemy.component(ofType: ParticleComponent.self)?.particleEffect
        expect(spriteNode.children).to(contain(emitterNode))
      }
    }
    
    describe("MoveComponent") {
      var moveComponent: MoveComponent!
      var entityManager: EntityManager!
      beforeEach {
        entityManager = EntityManager(scene: GameScene())
        spriteNode = SKSpriteNode(color: .blue, size: CGSize(width: 10, height: 20))
        enemy = EnemyEntity(node: spriteNode, entityManager: entityManager)
        moveComponent = enemy.component(ofType: MoveComponent.self)
      }
      
      it("should have MoveComponent") {
        expect(moveComponent).toNot(beNil())
      }
      
      it("should set maxSpeed to entity defined maxSpeed") {
        expect(moveComponent.maxSpeed).to(equal(enemy.maxSpeed))
      }
      
      it("should set maxAcceleration to entity defined maxAcceleration") {
        expect(moveComponent.maxAcceleration).to(equal(enemy.maxAcceleration))
      }
      
      it("should set radius to half of spriteNode width") {
        let expectedRadius = Float(spriteNode.size.width * 0.5)
        expect(moveComponent.radius).to(equal(expectedRadius))
      }
      
      it("should set mass to entity defined mass") {
        expect(moveComponent.mass).to(equal(enemy.mass))
      }
      
      it("should have a reference to entityManager")   {
        expect(moveComponent.entityManager).to(be(entityManager))
      }
    }
  }
}
