//
//  MoveBehaviorTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/5/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class MoveBehaviorSpec: QuickSpec {
  override func spec() {
    describe("MoveBehavior") {
      var behavior: MoveBehavior!
      let expectedGoalCount = 3
      let weightToReachTargetSpeed: Float = 0.1
      let weightToSeekAgent: Float = 0.8
      let weightToAvoidAgents: Float = 0.3
      
      let targetSpeed: Float = 200
      let agent = GKAgent()
      let agents = [GKAgent()]
      
      beforeEach {
        behavior = MoveBehavior(targetSpeed: targetSpeed, seek: agent, avoid: agents)
      }
      
      it("should have three goals") {
        expect(behavior.goalCount).to(equal(expectedGoalCount))
      }
      
      it("should have a goal toReachTargetSpeed with expected weight") {
        expect(behavior.weight(for: behavior.goalToReachTargetSpeed)).to(equal(weightToReachTargetSpeed))
      }
      
      it("should have a goal toSeekAgent with expected weight") {
        expect(behavior.weight(for: behavior.goalToSeekAgent)).to(equal(weightToSeekAgent))
      }
      
      it("should have a goal toAvoidAgents with expected weight") {
        expect(behavior.weight(for: behavior.goalToAvoidAgents)).to(equal(weightToAvoidAgents))
      }
    }
  }
}
