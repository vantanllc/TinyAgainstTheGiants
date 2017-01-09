//
//  TeamComponentTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/5/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class TeamComponentSpec: QuickSpec {
  override func spec() {
    var teamComponent: TeamComponent!
    
    describe("TeamComponent") {
      it("should have a Team") {
        let team = Team.One
        teamComponent = TeamComponent(team: team)
        expect(teamComponent.team).to(equal(team))
      }
    }
  }
}
