//
//  SpriteComponentTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class SpriteComponentSpec: QuickSpec {
  override func spec() {
    var spriteComponent: SpriteComponent!
    
    describe("SpriteComponent") {
      it("should have a SKSpriteNode") {
        let sprite = SKSpriteNode()
        spriteComponent = SpriteComponent(node: sprite)
        expect(spriteComponent.node).to(be(sprite))
      }
    }
  }
}
