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
      
      it("should have a TeamComponent with Team.One") {
        let team = player.component(ofType: TeamComponent.self)?.team
        expect(team).to(equal(Team.One))
      }
      
      it("should have a PhysicsComponent") {
        let physicsComponent = player.component(ofType: PhysicsComponent.self)
        expect(physicsComponent).toNot(beNil())
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
      
      it("should have SpriteComponent") {
        let spriteComponent = player.component(ofType: SpriteComponent.self)
        expect(spriteComponent).toNot(beNil())
      }
      
      it("should add SpriteComponent.node as a child of RenderComponent.node") {
        let renderComponent: RenderComponent! = player.component(ofType: RenderComponent.self)
        expect(renderComponent.node.children).to(contain(spriteNode))
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
    }
  }
}
