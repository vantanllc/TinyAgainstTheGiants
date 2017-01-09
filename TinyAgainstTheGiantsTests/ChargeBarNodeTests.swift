//
//  ChargeBarNodeTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/8/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class ChargeBarNodeSpec: QuickSpec {
  override func spec() {
    describe("ChargeBarNode") {
      var chargeBarNode: ChargeBarNode!
      
      beforeEach {
        chargeBarNode = ChargeBarNode()
      }
      
      it("should have default background color set") {
        expect(chargeBarNode.color).to(equal(ChargeBarNode.Configuration.backgroundColor))
      }
      
      it("should have default size set") {
        expect(chargeBarNode.size).to(equal(ChargeBarNode.Configuration.size))
      }
      
      it("should have chargeLevelNode as child") {
        expect(chargeBarNode.children).to(contain(chargeBarNode.chargeLevelNode))
      }
      
      it("should have level default to 1.0") {
        expect(chargeBarNode.level).to(equal(1))
      }
      
      describe("chargeLevelNode") {
        var chargeLevelNode: SKSpriteNode!
        
        beforeEach {
          chargeLevelNode = chargeBarNode.chargeLevelNode
        }
        
        it("should have two constraints") {
          expect(chargeLevelNode.constraints).to(haveCount(1))
        }
        
        it("should have specified color set") {
          expect(chargeLevelNode.color).to(equal(ChargeBarNode.Configuration.chargeLevelColor))
        }
        
        it("should have specified size set") {
          expect(chargeLevelNode.size).to(equal(ChargeBarNode.Configuration.chargeLevelNodeSize))
        }
        
        it("should have constraints referenced to ChargeBarNode") {
          let constraint: SKConstraint! = chargeLevelNode.constraints?.first
          expect(constraint.referenceNode).to(be(chargeBarNode))
        }
        
        it("should have expected anchor point") {
          expect(chargeLevelNode.anchorPoint).to(equal(CGPoint(x: 0, y: 0.5)))
        }
        
        it("should run SKAction once level property is updated") {
          chargeBarNode.level = 0.5
          expect(chargeLevelNode.hasActions()).to(beTrue())
        }
      }
    }
  }
}
