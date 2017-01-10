//
//  ChargeBarComponentSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/9/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class ChargeBarComponentSpec: QuickSpec {
  override func spec() {
    var chargeBarComponent: ChargeBarComponent!
    let charge: Double = 20
    let maxCharge: Double = 100
    let chargeToAdd: Double = 65
    let chargeToLose: Double = 16
    
    describe("ChargeBarComponent") {
      context("displayChargeBar is enabled") {
        beforeEach {
          chargeBarComponent = ChargeBarComponent(charge: charge, maxCharge: maxCharge, displayChargeBar: true)
        }
        
        it("should set maxCharge as specified") {
          expect(chargeBarComponent.maxCharge).to(equal(maxCharge))
        }
        
        it("should set charge as specified") {
          expect(chargeBarComponent.charge).to(equal(charge))
        }
        
        it("should have chargeBarNode") {
          expect(chargeBarComponent.chargeBarNode).toNot(beNil())
        }
        
        it("should have calculated percentage correctly") {
          expect(chargeBarComponent.percentage).to(equal(charge / maxCharge))
        }
        
        it("should set chargeBarNode.level to percentage") {
          expect(chargeBarComponent.chargeBarNode?.level).to(equal(chargeBarComponent.percentage))
        }
        
        context("addCharge") {
          it("should add specified charge to charge") {
            chargeBarComponent.addCharge(chargeToAdd: chargeToAdd)
            expect(chargeBarComponent.charge).to(equal(charge + chargeToAdd))
          }
          
          it("should update chargeBarNode.level with new percent") {
            chargeBarComponent.addCharge(chargeToAdd: chargeToAdd)
            expect(chargeBarComponent.chargeBarNode?.level).to(equal((charge + chargeToAdd) / maxCharge))
          }
          
          it("should limit charge to maxCharge") {
            chargeBarComponent.addCharge(chargeToAdd: chargeToAdd)
            chargeBarComponent.addCharge(chargeToAdd: chargeToAdd)
            expect(chargeBarComponent.charge).to(equal(maxCharge))
          }
          
          it("should limit chargeBarNode.level to 1") {
            chargeBarComponent.addCharge(chargeToAdd: chargeToAdd)
            chargeBarComponent.addCharge(chargeToAdd: chargeToAdd)
            expect(chargeBarComponent.chargeBarNode?.level).to(equal(1))
          }
          
          it("should not change charge if chargeToAdd is zero") {
            chargeBarComponent.addCharge(chargeToAdd: 0)
            expect(chargeBarComponent.charge).to(equal(charge))
          }
          
          it("should not change chargeBarNode.level if chargeToAdd is zero") {
            chargeBarComponent.addCharge(chargeToAdd: 0)
            expect(chargeBarComponent.chargeBarNode?.level).to(equal(charge / maxCharge))
          }
        }
        
        context("loseCharge") {
          it("should subtract specified charge to charge") {
            chargeBarComponent.loseCharge(chargeToLose: chargeToLose)
            expect(chargeBarComponent.charge).to(equal(charge - chargeToLose))
          }
          
          it("should update chargeBarNode.level with new percent") {
            chargeBarComponent.loseCharge(chargeToLose: chargeToLose)
            expect(chargeBarComponent.chargeBarNode?.level).to(equal((charge - chargeToLose) / maxCharge))
          }
          
          it("should limit charge to zero") {
            chargeBarComponent.loseCharge(chargeToLose: chargeToLose)
            chargeBarComponent.loseCharge(chargeToLose: chargeToLose)
            expect(chargeBarComponent.charge).to(equal(0))
          }
          
          it("should limit chargeBarNode.level to 0") {
            chargeBarComponent.loseCharge(chargeToLose: chargeToLose)
            chargeBarComponent.loseCharge(chargeToLose: chargeToLose)
            expect(chargeBarComponent.chargeBarNode?.level).to(equal(0))
          }
          
          it("should not change charge if chargeToLose is zero") {
            chargeBarComponent.loseCharge(chargeToLose: 0)
            expect(chargeBarComponent.charge).to(equal(charge))
          }
          
          it("should not change chargeBarNode.level if chargeToLose is zero") {
            chargeBarComponent.loseCharge(chargeToLose: 0)
            expect(chargeBarComponent.chargeBarNode?.level).to(equal(charge / maxCharge))
          }
        }
      }
      
      context("displayChargeBar is disabled by default") {
        beforeEach {
          chargeBarComponent = ChargeBarComponent(charge: charge, maxCharge: maxCharge)
        }
        
        it("should not have chargeBarNode") {
          expect(chargeBarComponent.chargeBarNode).to(beNil())
        }
      }
      
      context("when maxCharge is zero") {
        it("should calculate percentage as zero") {
          chargeBarComponent = ChargeBarComponent(charge: 50, maxCharge: 0)
          expect(chargeBarComponent.percentage.isZero).to(beTrue())
        }
      }
    }
  }
}
