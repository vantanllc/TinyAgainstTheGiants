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
      
      it("should have a PhysicsComponent") {
        let physicsComponent = enemy.component(ofType: PhysicsComponent.self)
        expect(physicsComponent).toNot(beNil())
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
      
      it("should have SpriteComponent") {
        let spriteComponent = enemy.component(ofType: SpriteComponent.self)
        expect(spriteComponent).toNot(beNil())
      }
      
      it("should add SpriteComponent.node as a child of RenderComponent.node") {
        let renderComponent: RenderComponent! = enemy.component(ofType: RenderComponent.self)
        expect(renderComponent.node.children).to(contain(spriteNode))
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
