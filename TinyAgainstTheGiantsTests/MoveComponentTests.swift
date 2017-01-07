//
//  MoveComponentTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/5/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class MoveComponentSpec: QuickSpec {
  override func spec() {
    var moveComponent: MoveComponent!
    let maxSpeed: Float = 100
    let maxAcceleration: Float = 200
    let radius: Float = 50
    let mass: Float = 10
    let entityManager = EntityManager(scene: GameScene(size: CGSize.zero))
    
    describe("MoveComponent") {
      describe("with entityManager") {
        beforeEach {
          moveComponent = MoveComponent(maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: radius, mass: mass, entityManager: entityManager)
        }
        
        it("should have an entityManager") {
          expect(moveComponent.entityManager).to(be(entityManager))
        }
      
        it("should set maxSpeed as specified") {
          expect(moveComponent.maxSpeed).to(equal(maxSpeed))
        }
        
        it("should set maxAcceleration as specified") {
          expect(moveComponent.maxAcceleration).to(equal(maxAcceleration / mass))
        }
        
        it("should set radius as specified") {
          expect(moveComponent.radius).to(equal(radius))
        }
        
        it("should set mass as specified") {
          expect(moveComponent.mass).to(equal(mass))
        }
      }
      
      describe("without entityManager") {
        beforeEach {
          moveComponent = MoveComponent(maxSpeed: maxSpeed, maxAcceleration: maxAcceleration, radius: radius, mass: mass)
        }
        
        it("should not have entityManager") {
          expect(moveComponent.entityManager).to(beNil())
        }
      }
    }
  }
}
