//
//  GameScenePauseStateSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/16/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class GameScenePauseStateSpec: QuickSpec {
  override func spec() {
    describe("GameScenePauseState") {
      var pauseState: GameScenePauseState!
      var gameScene: GameScene!
      
      beforeEach {
        gameScene = GameScene()
        pauseState = GameScenePauseState(gameScene: gameScene)
        gameScene.startNewGame()
      }
    
      it("should have gameScene") {
        expect(pauseState.gameScene).to(be(gameScene))
      }
      
      context("isValidNextState") {
        it("should return true for ActiveState") {
          let isValid = pauseState.isValidNextState(GameSceneActiveState.self)
          expect(isValid).to(beTrue())
        }
      }
      
      context("didEnter") {
        beforeEach {
          pauseState.didEnter(from: nil)
        }
       
        it("should add resume button to gameScene") {
          expect(pauseState.resumeButton.parent).to(be(gameScene))
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
          let resumeButton = ButtonBuilder.createButton(withIdentifier: .resume)
          pauseState.resumeButton = resumeButton
          gameScene.addChild(resumeButton)
          pauseState.willExit(to: GKState())
        }
        
        it("should remove resume button") {
          expect(pauseState.resumeButton.parent).to(beNil())
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
