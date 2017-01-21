//
//  GameSceneFailStateSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/15/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class GameSceneFailStateSpec: QuickSpec {
  override func spec() {
    describe("GameSceneActiveState") {
      var gameSceneFailState: GameSceneFailState!
      var gameScene: GameScene!
      
      beforeEach {
        gameScene = GameScene()
        gameScene.didMove(to: SKView())
        gameSceneFailState = GameSceneFailState(gameScene: gameScene)
      }
      
      it("should have gameScene") {
        expect(gameSceneFailState.gameScene).to(be(gameScene))
      }
      
      context("isValidNextState") {
        it("should return true for ActiveState") {
          let isValid = gameSceneFailState.isValidNextState(GameSceneActiveState.self)
          expect(isValid).to(beTrue())
        }
      }
      
      context("didEnter") {
        beforeEach {
          gameSceneFailState.didEnter(from: nil)
        }
        
        it("should add retry button to gameScene") {
          expect(gameScene.childNode(withName: ButtonIdentifier.retry.rawValue)).toNot(beNil())
        }
        
        it("should set retry button y position above the player entity render node") {
          let renderNodeYPosition = gameScene.entityManager.getPlayerRenderNode()?.position.y
          let retryButtonYPosition = gameScene.childNode(withName: ButtonIdentifier.retry.rawValue)!.position.y - 100
          expect(retryButtonYPosition).to(equal(renderNodeYPosition))
        }
        
        it("should set retry button x position the same as the player entity render node") {
          let renderNodeXPosition = gameScene.entityManager.getPlayerRenderNode()?.position.x
          let retryButtonXPosition = gameScene.childNode(withName: ButtonIdentifier.retry.rawValue)!.position.x
          expect(retryButtonXPosition).to(equal(renderNodeXPosition))
          
        }
        
        it("should pause the worldNode") {
          expect(gameScene.worldNode.isPaused).to(beTrue())
        }
        
        it("should set physicsworld speed to zero") {
          expect(gameScene.physicsWorld.speed.isZero).to(beTrue())
        }
      }
      
      context("willExit") {
        beforeEach {
          gameScene.worldNode.isPaused = true
          gameScene.physicsWorld.speed = 0
          gameScene.addChild(ButtonBuilder.getRetryButton())
          gameSceneFailState.willExit(to: GKState())
        }
        
        it("should remove retry button") {
          expect(gameScene.childNode(withName: ButtonIdentifier.retry.rawValue)).to(beNil())
        }
        
        it("should unpause the worldNode") {
          expect(gameScene.worldNode.isPaused).to(beFalse())
        }
        
        it("should set physics world speed back to one") {
          expect(gameScene.physicsWorld.speed).to(equal(1))
        }
      }
    }
  }
}
