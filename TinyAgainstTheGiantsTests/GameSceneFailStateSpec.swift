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
        gameScene.startNewGame()
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
        var activeState: GameSceneActiveState!
        
        beforeEach {
          activeState = GameSceneActiveState(gameScene: gameScene)
          activeState.timerNode = SKLabelNode(text: "Whatever")
          activeState.timerNode.position = CGPoint(x: 100, y: 300)
          gameSceneFailState.didEnter(from: activeState)
        }
        
        context("retry button") {
          it("should add to gameScene") {
            expect(gameSceneFailState.retryButton.parent).to(be(gameScene))
          }
          
          it("should set y position above the player entity render node") {
            let renderNodeYPosition = gameScene.entityManager.getPlayerRenderNode()?.position.y
            let retryButtonYPosition = gameSceneFailState.retryButton.position.y - 100
            expect(retryButtonYPosition).to(equal(renderNodeYPosition))
          }
          
          it("should set x position the same as the player entity render node") {
            let renderNodeXPosition = gameScene.entityManager.getPlayerRenderNode()?.position.x
            let retryButtonXPosition = gameSceneFailState.retryButton.position.x
            expect(retryButtonXPosition).to(equal(renderNodeXPosition))
          }
        }
        
        context("bestTimeNode") {
          it("should add bestTimeNode to gameScene.camera") {
            expect(gameSceneFailState.bestTimeNode.parent).to(be(gameScene.camera))
          }
          
          it("should set x position the same as the timerLabel") {
            expect(gameSceneFailState.bestTimeNode.position.x).to(equal(activeState.timerNode.position.x))
          }
          
          it("should set y position below the timerLabel") {
            let expectedPosition = activeState.timerNode.position.applying(CGAffineTransform.init(translationX: 0, y: -activeState.timerNode.frame.size.height))
            expect(gameSceneFailState.bestTimeNode.position.y).to(equal(expectedPosition.y))
          }
          
          it("should set fontSize to expected") {
            expect(gameSceneFailState.bestTimeNode.fontSize).to(equal(GameSceneFailState.Configuration.bestTimeLabelFontSize))
          }
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
          
          let retryButton = ButtonBuilder.createButton(withIdentifier: .retry)
          gameSceneFailState.retryButton = retryButton
          gameScene.addChild(retryButton)
          
          let bestTimeNode = LabelBuilder.createTimerLabel()
          gameSceneFailState.bestTimeNode = bestTimeNode
          gameScene.camera?.addChild(bestTimeNode)
          
          gameSceneFailState.willExit(to: GKState())
        }
        
        it("should remove bestTimeNode") {
          expect(gameSceneFailState.bestTimeNode.parent).to(beNil())
        }
        
        it("should remove retry button") {
          expect(gameSceneFailState.retryButton.parent).to(beNil())
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
