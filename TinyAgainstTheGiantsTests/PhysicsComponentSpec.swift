//
//  PhysicsComponentTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/2/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class PhysicsComponentSpec: QuickSpec {
  override func spec() {
    var physicsComponent: PhysicsComponent!
    var colliderType: ColliderType!
    var body: SKPhysicsBody!
    describe("PhysicsComponent") {
      beforeEach {
        colliderType = .Player
        ColliderType.definedCollisions = [.Player: [.Enemy, .Obstacle]]
        ColliderType.requestedContactNotifications = [.Player: [.Enemy]]
        body = SKPhysicsBody()
        physicsComponent = PhysicsComponent(physicsBody: body, colliderType: colliderType)
      }
      
      afterEach {
        ColliderType.definedCollisions.removeAll()
        ColliderType.requestedContactNotifications.removeAll()
      }
      it("should have a PhysicsBody") {
        expect(physicsComponent.physicsBody).to(be(body))
      }
      
      describe("with collideType argument") {
        it("should set categoryMask to match colliderType") {
          expect(body.categoryBitMask).to(equal(colliderType.categoryMask))
        }
        it("should set collisionMask to match colliderType") {
          expect(body.collisionBitMask).to(equal(colliderType.collisionMask))
        }
        it("should set contactMask to match colliderType") {
          expect(body.contactTestBitMask).to(equal(colliderType.contactMask))
        }
        
      }
    }
  }
}
