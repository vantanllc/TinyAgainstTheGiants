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
        
        it("should set playerEntity physicsbody to static") {
          let body = gameScene.entityManager.getPlayerEntity()?.component(ofType: PhysicsComponent.self)?.physicsBody
          expect(body?.isDynamic).to(beFalse())
        }
      }
    }
  }
}
