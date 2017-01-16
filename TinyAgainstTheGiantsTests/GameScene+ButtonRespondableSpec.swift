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
      var gameScene: GameScene!
      
      beforeEach {
        gameScene = GameScene()
      }
      
      describe("buttonTrigger") {
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
