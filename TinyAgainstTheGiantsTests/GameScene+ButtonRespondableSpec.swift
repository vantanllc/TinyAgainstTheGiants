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
      
      class MockGameScene: GameScene {
        override func showCredits() {
          showCreditsWasCalled = true
        }
        
        var showCreditsWasCalled = false
      }
      
      beforeEach {
        gameScene = MockGameScene()
      }
      
      describe("buttonTrigger") {
        context("credits") {
          var button: ButtonNode!
          
          beforeEach {
            button = ButtonNode()
            button.name = ButtonIdentifier.credits.rawValue
            gameScene.buttonTriggered(button: button)
          }
          
          it("should show credits alertview") {
            expect(gameScene.showCreditsWasCalled).to(beTrue())
          }
        }
        
        context("pause") {
          var button: ButtonNode!
          
          beforeEach {
            button = ButtonNode()
            button.name = ButtonIdentifier.pause.rawValue
            gameScene.buttonTriggered(button: button)
          }
          
          it("should enter PauseState") {
            expect(gameScene.stateMachine.currentState).to(beAKindOf(GameScenePauseState.self))
          }
        }
        
        context("start") {
          var button: ButtonNode!
          
          beforeEach {
            button = ButtonNode()
            button.name = ButtonIdentifier.start.rawValue
            gameScene.buttonTriggered(button: button)
          }
          
          it("should enter ActiveState") {
            expect(gameScene.stateMachine.currentState).to(beAKindOf(GameSceneActiveState.self))
          }
        }
        
        context("resume") {
          var button: ButtonNode!
          
          beforeEach {
            button = ButtonNode()
            button.name = ButtonIdentifier.resume.rawValue
            gameScene.stateMachine.enter(GameSceneFailState.self)
            gameScene.buttonTriggered(button: button)
          }
          
          it("should enter ActiveState") {
            expect(gameScene.stateMachine.currentState).to(beAKindOf(GameSceneActiveState.self))
          }
        }
        
        context("retry") {
          var button: ButtonNode!
          
          beforeEach {
            for _ in 1...10 {
              gameScene.entityManager.add(entity: GKEntity())
            }
            button = ButtonNode()
            button.name = ButtonIdentifier.retry.rawValue
            gameScene.stateMachine.enter(GameSceneFailState.self)
            gameScene.buttonTriggered(button: button)
          }
          
          it("should remove all entities and add only the player entity") {
            expect(gameScene.entityManager.entities).to(haveCount(1))
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
