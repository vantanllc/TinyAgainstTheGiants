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
    
    describe("PhysicsComponent") {
      it("should have a PhysicsBody") {
        let body = SKPhysicsBody()
        physicsComponent = PhysicsComponent(physicsBody: body)
        expect(physicsComponent.physicsBody).to(be(body))
      }
    }
  }
}
