//
//  EntityBuilderTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/1/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class EntityBuilderSpec: QuickSpec {
  override func spec() {
    var entityManager: EntityManager!
    var scene: GameScene!
    
    describe("EntityBuilder") {
      beforeEach {
        scene = GameScene()
        entityManager = EntityManager(scene: scene)
      }
      
      describe("addPlayer") {
        let position = CGPoint(x: 200, y: -20)

        beforeEach {
          EntityBuilder.addPlayer(position: position, toEntityManager: entityManager)
        }
        
        it("should add PlayerEntity to entityManager") {
          if let entity = entityManager.getPlayerEntity() {
            expect(entity).toNot(beNil())
          } else {
            fail("Unexpectedly found nil")
          }
        }
        
        it("should set PlayerEntity RenderComponent position") {
          if let node = entityManager.getPlayerRenderNode() {
            expect(node.position).to(equal(position))
          } else {
            fail("Unexpectedly found nil")
          }
        }
      }
    }
  }
}
