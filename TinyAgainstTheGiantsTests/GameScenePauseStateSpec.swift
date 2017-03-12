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
        it("should add resume button to gameScene") {
          pauseState.didEnter(from: nil)
          expect(pauseState.resumeButton.parent).to(be(gameScene))
        }
        
        context("musicButton") {
          it("should be added to camera") {
            pauseState.didEnter(from: nil)
            expect(pauseState.musicButton.parent).to(be(gameScene.camera))
          }
          
          it("should be musicOn identifier if sound is enabled") {
            Sound.current.isEnabled = true
            pauseState.didEnter(from: nil)
            expect(pauseState.musicButton.buttonIdentifier).to(equal(ButtonIdentifier.musicOn))
          }
          
          it("should be musicOff identifier if sound is not enabled") {
            Sound.current.isEnabled = false
            pauseState.didEnter(from: nil)
            expect(pauseState.musicButton.buttonIdentifier).to(equal(ButtonIdentifier.musicOff))
          }
        }
        
        it("should pause the worldNode") {
          pauseState.didEnter(from: nil)
          expect(gameScene.worldNode.isPaused).to(beTrue())
        }
        
        it("should set physicsworld speed to zero") {
          pauseState.didEnter(from: nil)
          expect(gameScene.physicsWorld.speed.isZero).to(beTrue())
        }
      }
      
      context("willExit") {
        it("should remove resume button") {
          let resumeButton = ButtonBuilder.createButton(withIdentifier: .resume)
          pauseState.resumeButton = resumeButton
          gameScene.camera?.addChild(resumeButton)
          pauseState.willExit(to: GKState())
          expect(pauseState.resumeButton.parent).to(beNil())
        }
        
        it("should remove music button") {
          let musicButton = ButtonBuilder.createButton(withIdentifier: .musicOn)
          pauseState.musicButton = musicButton
          gameScene.camera?.addChild(musicButton)
          pauseState.willExit(to: GKState())
          expect(pauseState.musicButton.parent).to(beNil())
        }
        
        it("should unpause the worldNode") {
          gameScene.worldNode.isPaused = true
          pauseState.willExit(to: GKState())
          expect(gameScene.worldNode.isPaused).to(beFalse())
        }
        
        it("should set physics world speed back to one") {
          gameScene.physicsWorld.speed = 0
          pauseState.willExit(to: GKState())
          expect(gameScene.physicsWorld.speed).to(equal(1))
        }
      }
    }
  }
}
