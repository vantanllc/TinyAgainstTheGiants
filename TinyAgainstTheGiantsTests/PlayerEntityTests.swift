//
//  PlayerEntityTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class PlayerEntitySpec: QuickSpec {
  override func spec() {
    var player: PlayerEntity!
    var spriteNode: SKSpriteNode!
    
    describe("PlayerEntity") {
      beforeEach {
        spriteNode = SKSpriteNode()
        player = PlayerEntity(node: spriteNode)
      }
      
      it("should have a RenderComponent") {
        let renderComponent = player.component(ofType: RenderComponent.self)
        expect(renderComponent).toNot(beNil())
      }
      
      it("should have SpriteComponent") {
        let spriteComponent = player.component(ofType: SpriteComponent.self)
        expect(spriteComponent).toNot(beNil())
      }
      
      it("should add SpriteComponent.node as a child of RenderComponent.node") {
        let renderComponent: RenderComponent! = player.component(ofType: RenderComponent.self)
        expect(renderComponent.node.children).to(contain(spriteNode))
      }
    }
  }
}
