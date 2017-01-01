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
    var scene: SKScene!
    
    describe("EntityBuilder") {
      beforeEach {
        scene = SKScene()
        entityManager = EntityManager(scene: scene)
      }
      
      describe("addPlayer") {
        it("should add PlayerEntity to entityManager") {
          let position = CGPoint.zero
          EntityBuilder.addPlayer(position: position, toEntityManager: entityManager)
          
          let playerEntity = entityManager.getPlayerEntity()
          expect(playerEntity).toNot(beNil())
        }
      }
    }
  }
}
