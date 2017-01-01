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
      
      describe("constraintCameraToPlayer") {
        it("should update camera constraint") {
          let camera = SKCameraNode()
          gameScene.camera = camera
          gameScene.entityManager.entities.insert(PlayerEntity(node: SKSpriteNode()))
          gameScene.constraintCameraToPlayer()
          expect(camera.constraints).to(haveCount(1))
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
      }
      
      describe("startNewGame") {
        it("should add player's RenderComponent node to scene") {
          gameScene.startNewGame()
          if let expectedPlayerRenderNode = gameScene.entityManager.getPlayerRenderNode() {
            expect(gameScene.children).to(contain(expectedPlayerRenderNode))
          } else {
            fail("Unexpectedly got nil.")
          }
        }
      }
    }
  }
}
