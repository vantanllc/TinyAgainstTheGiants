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
      
      describe("tilemap functions") {
        describe("addBackgroundTileMap") {
          it("should add currentBackgroundTileMap to scene as child") {
            gameScene.addBackgroundTileMap()
            expect(gameScene.currentBackgroundTileMap.scene).to(be(gameScene))
          }
        }
        
        describe("addObstacleTileMap") {
          it("should add currentObstacleTileMap to scene as child") {
            gameScene.addObstacleTileMap()
            expect(gameScene.currentObstacleTileMap.scene).to(be(gameScene))
          }
        }
      }
      
      describe("startCamera") {
        it("should set gameScene.camera") {
          gameScene.startCamera()
          expect(gameScene.camera).toNot(beNil())
        }
      }
      
      describe("sceneDidLoad") {
        it("should initialize entityManager") {
          gameScene.sceneDidLoad()
          expect(gameScene.entityManager).toNot(beNil())
        }
        
        it("should initialize worldNode") {
          gameScene.sceneDidLoad()
          expect(gameScene.worldNode).toNot(beNil())
        }
        
        it("should add worldNode to scene") {
          gameScene.sceneDidLoad()
          expect(gameScene.children).to(contain(gameScene.worldNode))
        }
      }
      
      describe("startNewGame") {
        it("should add player's RenderComponent node to worldNode") {
          gameScene.startNewGame()
          if let expectedPlayerRenderNode = gameScene.entityManager.getPlayerRenderNode() {
            expect(gameScene.worldNode.children).to(contain(expectedPlayerRenderNode))
          } else {
            fail("Unexpectedly got nil.")
          }
        }
      }
    }
  }
}
