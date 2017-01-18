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
        gameScene.didMove(to: SKView())
        pauseState = GameScenePauseState(gameScene: gameScene)
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
          expect(gameScene.childNode(withName: ButtonIdentifier.resume.rawValue)).toNot(beNil())
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
          gameScene.addChild(ButtonBuilder.getPauseButton())
          pauseState.willExit(to: GKState())
        }
        
        it("should remove resume button") {
          expect(gameScene.childNode(withName: ButtonIdentifier.resume.rawValue)).to(beNil())
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
