//
//  GameSceneActiveStateSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/13/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class GameSceneActiveStateSpec: QuickSpec {
  override func spec() {
    describe("GameSceneActiveState") {
      var gameSceneActiveState: GameSceneActiveState!
      var gameScene: GameScene!
      
      beforeEach {
        gameScene = GameScene()
        gameSceneActiveState = GameSceneActiveState(gameScene: gameScene)
      }
      
      it("should have gameScene") {
        expect(gameSceneActiveState.gameScene).to(be(gameScene))
      }
      
      it("should default to starting time") {
        expect(gameSceneActiveState.time).to(equal(gameSceneActiveState.startTime))
      }
      
      context("timeString") {
        it("should convert time to minute second string") {
          gameSceneActiveState.time = 96
          let expectedTimeString = "1:36"
          expect(gameSceneActiveState.timeString).to(equal(expectedTimeString))
        }
      }
      
      context("check player's charge percentage") {
        it("should transition to FailState if equal zero") {
          gameScene.timerNode = SKLabelNode()
          gameScene.entityManager.getPlayerEntity()?.component(ofType: ChargeBarComponent.self)?.charge = 0
          gameScene.update(1)
          
          expect(gameScene.stateMachine.currentState).to(beAKindOf(GameSceneFailState.self))
        }
      }
      
      context("update gameScene timerNode") {
        var deltaTime: TimeInterval!
        beforeEach {
          deltaTime = 3
          gameScene.timerNode = SKLabelNode()
          gameSceneActiveState.update(deltaTime: deltaTime)
          
        }
        it("should increment time property by deltaTime") {
          expect(gameSceneActiveState.time).to(equal(deltaTime))
        }
        
        it("should update timerNode text to timeString") {
          expect(gameScene.timerNode.text).to(equal(gameSceneActiveState.timeString))
        }
      }
      
      context("didEnter") {
        context("from FailState") {
          it("should reset time to zero") {
            gameSceneActiveState.time = 304
            gameSceneActiveState.didEnter(from: GameSceneFailState(gameScene: GameScene()))
            expect(gameSceneActiveState.time.isZero).to(beTrue())
          }
        }
      }
    }
  }
}
