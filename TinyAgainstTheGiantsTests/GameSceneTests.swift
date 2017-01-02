//
//  GameSceneTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class GameSceneSpec: QuickSpec {
  override func spec() {
    var gameScene: GameScene!
    
    describe("GameScene") {
      beforeEach {
        gameScene = GameScene()
      }
      
      it("should initialize entityManager") {
        expect(gameScene.entityManager).toNot(beNil())
      }
      
      it("should initialize worldNode") {
        expect(gameScene.worldNode).toNot(beNil())
      }
      
      it("should add worldNode to scene") {
        expect(gameScene.children).to(contain(gameScene.worldNode))
      }
      
      it("should add currentBackgroundTileMap to scene as child") {
        expect(gameScene.currentBackgroundTileMap.scene).to(be(gameScene))
      }
      
      it("should add currentObstacleTileMap to scene as child") {
        expect(gameScene.currentObstacleTileMap.scene).to(be(gameScene))
      }
      
      it("should set gameScene.camera") {
        expect(gameScene.camera).toNot(beNil())
      }
      
      it("should initialize entityManager") {
        expect(gameScene.entityManager).toNot(beNil())
      }
      
      it("should initialize worldNode") {
        expect(gameScene.worldNode).toNot(beNil())
      }
      
      it("should add worldNode to scene") {
        expect(gameScene.children).to(contain(gameScene.worldNode))
      }
      
      it("should add player's RenderComponent node to worldNode") {
        if let expectedPlayerRenderNode = gameScene.entityManager.getPlayerRenderNode() {
          expect(gameScene.worldNode.children).to(contain(expectedPlayerRenderNode))
        } else {
          fail("Unexpectedly got nil.")
        }
      }
    }
  }
}
