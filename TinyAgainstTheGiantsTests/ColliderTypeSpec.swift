//
//  ColliderTypeSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/9/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class ColliderTypeSpec: QuickSpec {
  override func spec() {
    var colliderType: ColliderType!
    
    describe("ColliderType") {
      beforeEach {
        ColliderType.definedCollisions.removeAll()
        ColliderType.requestedContactNotifications.removeAll()
      }
      
      it("should return rawValue for categoryMask") {
        colliderType = .Obstacle
        expect(colliderType.categoryMask).to(equal(ColliderType.Obstacle.rawValue))
      }
      
      context("with definedCollisions") {
        it("should return correct unioned rawValue for collisionMask") {
          let expectedMask = ColliderType.Obstacle.union(.Enemy).rawValue
          ColliderType.definedCollisions = [.Player: [.Obstacle, .Enemy]]
          colliderType = .Player
          expect(colliderType.collisionMask).to(equal(expectedMask))
        }
      }
      
      context("without definedCollisions") {
        it("should return zero rawValue for collisionMask") {
          let expectedMask: UInt32 = 0
          colliderType = .Player
          expect(colliderType.collisionMask).to(equal(expectedMask))
        }
      }
      
      context("with requestedContactNotifications") {
        beforeEach {
          ColliderType.requestedContactNotifications = [.Player: [.Obstacle, .Enemy]]
          colliderType = .Player
        }
        
        it("should return correct unioned rawValue for requestedContactNotifications") {
          let expectedMask = ColliderType.Obstacle.union(.Enemy).rawValue
          expect(colliderType.contactMask).to(equal(expectedMask))
        }
        
        it("should return true for requested colliderType") {
          let shouldNotify = colliderType.notifyOnContactWith(.Enemy)
          expect(shouldNotify).to(beTrue())
        }
        
        it("should return false for requested colliderType") {
          let shouldNotify = colliderType.notifyOnContactWith(.Player)
          expect(shouldNotify).to(beFalse())
        }
      }
      context("without requestedContactNotifications") {
        it("should return zero rawValue for requestedContactNotifications") {
          let expectedMask: UInt32 = 0
          colliderType = .Player
          expect(colliderType.contactMask).to(equal(expectedMask))
        }
        
        it("should return false for requested colliderType") {
          let shouldNotify = colliderType.notifyOnContactWith(.Player)
          expect(shouldNotify).to(beFalse())
        }
      }
    }
  }
}
