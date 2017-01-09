//
//  RenderComponentTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class RenderComponentSpec: QuickSpec {
  override func spec() {
    var render: RenderComponent!
    var entity: GKEntity!
    
    describe("RenderComponent") {
      beforeEach {
        render = RenderComponent()
        entity = GKEntity()
      }
      
      it("should have a SKNode property") {
        expect(render.node).toNot(beNil())
      }
      
      describe("didAddToEntity") {
        it("should assign node.entity to self.entity") {
          entity.addComponent(render)
          expect(render.node.entity).to(be(entity))
        }
      }
      
      describe("willRemoveFromEntity") {
        it("should assign node.entity to nil") {
          entity.addComponent(render)
          entity.removeComponent(ofType: RenderComponent.self)
          expect(render.node.entity).to(beNil())
        }
      }
    }
  }
}
