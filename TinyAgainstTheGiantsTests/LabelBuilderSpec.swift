//
//  LabelBuilderSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 2/26/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class LabelBuilderSpec: QuickSpec {
  override func spec() {
    describe("LabelBuilder") {
      context("createTimerLabel") {
        var timer: SKLabelNode!
        
        beforeEach {
          timer = LabelBuilder.createTimerLabel()
        }
        
        it("should be default horizontal alignment") {
          expect(timer.horizontalAlignmentMode).to(equal(LabelBuilder.Default.horizontalAlignmentMode))
        }
        
        it("should be default vertical alignment") {
          expect(timer.verticalAlignmentMode).to(equal(LabelBuilder.Default.verticalAlignmentMode))
        }
        
        it("should have default fontSize") {
          expect(timer.fontSize).to(equal(LabelBuilder.Default.fontSize))
        }
        
        it("should have default zPosition") {
          expect(timer.zPosition).to(equal(LabelBuilder.Default.zPosition))
        }
        
        it("should have default fontName") {
          expect(timer.fontName).to(equal(LabelBuilder.Default.fontName))
        }
      }
      
    }
  }
}
