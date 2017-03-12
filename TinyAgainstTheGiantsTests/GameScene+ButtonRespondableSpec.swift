//
//  GameScene+ButtonRespondableSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/15/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class GameSceneButtonRespondableSpec: QuickSpec {
  override func spec() {
    describe("GameScene+ButtonRespondable") {
      var gameScene: MockGameScene!
      var button: ButtonNode!
      
      class MockGameScene: GameScene {
        override func showCredits() {
          showCreditsWasCalled = true
        }
        
        var showCreditsWasCalled = false
      }
      
      beforeEach {
        button = ButtonNode()
        gameScene = MockGameScene()
      }
      
      describe("buttonTrigger") {
        context("credits") {
          it("should show credits alertview") {
            button.name = ButtonIdentifier.credits.rawValue
            gameScene.buttonTriggered(button: button)
            expect(gameScene.showCreditsWasCalled).to(beTrue())
          }
        }
        
        context("pause") {
          it("should enter PauseState") {
            button.name = ButtonIdentifier.pause.rawValue
            gameScene.buttonTriggered(button: button)
            expect(gameScene.stateMachine.currentState).to(beAKindOf(GameScenePauseState.self))
          }
        }
        
        context("start") {
          it("should enter ActiveState") {
            button.name = ButtonIdentifier.start.rawValue
            gameScene.buttonTriggered(button: button)
            expect(gameScene.stateMachine.currentState).to(beAKindOf(GameSceneActiveState.self))
          }
        }
        
        context("resume") {
          it("should enter ActiveState") {
            button.name = ButtonIdentifier.resume.rawValue
            gameScene.stateMachine.enter(GameSceneFailState.self)
            gameScene.buttonTriggered(button: button)
            expect(gameScene.stateMachine.currentState).to(beAKindOf(GameSceneActiveState.self))
          }
        }
        
        context("musicButton") {
          beforeEach {
            gameScene.backgroundAudio = Sound.getBackgroundAudioPlayer()
          }
          
          afterEach {
            Sound.current.isEnabled = true
          }
          
          context("musicOn") {
            beforeEach {
              button.name = ButtonIdentifier.musicOn.rawValue
            }
            
            it("should disable sound") {
              Sound.current.isEnabled = true
              gameScene.buttonTriggered(button: button)
              expect(Sound.current.isEnabled).to(beFalse())
            }
            
            it("should pause backgroundAudio") {
              gameScene.backgroundAudio.play()
              gameScene.buttonTriggered(button: button)
              expect(gameScene.backgroundAudio.isPlaying).to(beFalse())
            }
            
            it("should update button identifier to musicOff") {
              gameScene.buttonTriggered(button: button)
              expect(button.buttonIdentifier).to(equal(ButtonIdentifier.musicOff))
            }
          }
          
          context("musicOff") {
            beforeEach {
              button.name = ButtonIdentifier.musicOff.rawValue
            }
            
            it("should enable sound") {
              Sound.current.isEnabled = false
              gameScene.buttonTriggered(button: button)
              expect(Sound.current.isEnabled).to(beTrue())
            }
            
            it("should resume backgroundAudio") {
              gameScene.backgroundAudio.pause()
              gameScene.buttonTriggered(button: button)
              expect(gameScene.backgroundAudio.isPlaying).to(beTrue())
            }
            
            it("should update button identifier to musicOn") {
              gameScene.buttonTriggered(button: button)
              expect(button.buttonIdentifier).to(equal(ButtonIdentifier.musicOn))
            }
          }
        }
        
        context("retry") {
          beforeEach {
            for _ in 1...10 {
              gameScene.entityManager.add(entity: GKEntity())
            }
            button.name = ButtonIdentifier.retry.rawValue
            gameScene.stateMachine.enter(GameSceneFailState.self)
            gameScene.buttonTriggered(button: button)
          }
          
          it("should remove all entities except for player") {
            expect(gameScene.entityManager.entities).to(haveCount(1))
          }
          
          it("should add only the player entity") {
            expect(gameScene.entityManager.getPlayerEntity()).toNot(beNil())
          }
          
          it("should transition state machine to ActiveState") {
            expect(gameScene.stateMachine.currentState).to(beAKindOf(GameSceneActiveState.self))
          }
        }
      }
    }
  }
}
