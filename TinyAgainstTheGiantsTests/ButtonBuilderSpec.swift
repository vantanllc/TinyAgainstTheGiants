//
//  ButtonBuilderSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/15/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class ButtonBuilderSpec: QuickSpec {
  override func spec() {
    describe("ButtonBuilder") {
      context("createButton") {
        var button: ButtonNode!
        var identifier: ButtonIdentifier!
        
        beforeEach {
          identifier = .retry
          button = ButtonBuilder.createButton(withIdentifier: identifier)
        }
        
        it("should return ButtonNode") {
          expect(button).toNot(beNil())
        }
        
        it("should be user enabled") {
          expect(button.isUserInteractionEnabled).to(beTrue())
        }
        
        it("should be named with ButtonIdentifier.retry") {
          expect(button.name).to(equal(identifier.rawValue))
        }
        
        it("should have zPosition of .button") {
          expect(button.zPosition).to(equal(NodeLayerPosition.button))
        }
      }
    }
  }
}
