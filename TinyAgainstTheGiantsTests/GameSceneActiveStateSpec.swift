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
        gameScene.startNewGame()
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
          gameScene.entityManager.getPlayerEntity()?.component(ofType: ChargeBarComponent.self)?.charge = 0
          gameScene.update(1)
          
          expect(gameScene.stateMachine.currentState).to(beAKindOf(GameSceneFailState.self))
        }
      }
      
      context("update spawn enemy") {
        beforeEach {
          gameScene.didMove(to: SKView())
        }
        
        context("after reaching cooldown time") {
          it("should increment enemyCount by one") {
            gameScene.addEnemy()
            let oldEnemyCount = gameScene.entityManager.getEnemyEntities()!.count
            
            gameSceneActiveState.update(deltaTime: gameScene.enemySpawnCoolDown)
            
            let newEnemyCount = gameScene.entityManager.getEnemyEntities()?.count
            expect(newEnemyCount).to(equal(oldEnemyCount + 1))
          }
          
          it("should reset enemySpawnTime to enemySpawnCoolDown") {
            gameSceneActiveState.update(deltaTime: gameScene.enemySpawnCoolDown + 0.1)
            
            expect(gameScene.enemySpawnTime).to(equal(gameScene.enemySpawnCoolDown))
          }
          
          it("should not exceed maxEnemyCount") {
            let maxCount = gameScene.maxEnemyCount
            for _ in 0...maxCount {
              gameSceneActiveState.update(deltaTime: gameScene.enemySpawnCoolDown)
            }
            
            expect(gameScene.entityManager.getEnemyEntities()!.count).to(equal(maxCount))
          }
        }
      }
      
      context("update gameScene timerNode") {
        var deltaTime: TimeInterval!
        
        beforeEach {
          deltaTime = 3
          gameSceneActiveState.update(deltaTime: deltaTime)
          
        }
        it("should increment time property by deltaTime") {
          expect(gameSceneActiveState.time).to(equal(deltaTime))
        }
        
        it("should update timerNode text to timeString") {
          let timer = gameScene.camera?.childNode(withName: LabelIdentifier.timer.rawValue) as! SKLabelNode
          expect(timer.text).to(equal(gameSceneActiveState.timeString))
        }
      }
      
      context("update entityManager") {
        var mockEntityManager: MockEntityManager!
        
        beforeEach {
          mockEntityManager = MockEntityManager()
          gameScene.entityManager = mockEntityManager
        }
        
        it("should call entityManager.update") {
          gameSceneActiveState.update(deltaTime: 1)
          expect(mockEntityManager.didCallUpdate).to(beTrue())
        }
        
        class MockEntityManager: EntityManager {
          init() {
            super.init(scene: GameScene())
          }
          
          override func update(deltaTime: TimeInterval) {
            didCallUpdate = true
          }
          
          var didCallUpdate = false
        }
      }
    
      context("createTimerNode") {
        var timer: SKLabelNode!
        
        beforeEach {
          timer = gameSceneActiveState.createTimerNode()
        }
        
        it("should be center align") {
          expect(timer.horizontalAlignmentMode).to(equal(SKLabelHorizontalAlignmentMode.center))
        }
        
        it("should be top align") {
          expect(timer.verticalAlignmentMode).to(equal(SKLabelVerticalAlignmentMode.top))
        }
        
        it("should have fontSize 50") {
          expect(timer.fontSize).to(equal(50))
        }
        
        it("should have zPosition of NodeLayerPosition.label") {
          expect(timer.zPosition).to(equal(NodeLayerPosition.label))
        }
      }
      
      context("createPauseButton") {
        var pauseButton: ButtonNode!
        
        beforeEach {
          pauseButton = gameSceneActiveState.createPauseButton()
        }
        
        it("should have zPosition set to button") {
          expect(pauseButton.zPosition).to(equal(NodeLayerPosition.button))
        }
        
        it("should have expected anchorPoint") {
          let anchorPoint = CGPoint(x: 1, y: 0)
          expect(pauseButton.anchorPoint).to(equal(anchorPoint))
        }
        
        it("should have position in the lower right corner") {
          let position = CGPoint(x: gameScene.size.width * 0.5, y: -gameScene.size.height * 0.5)
          expect(pauseButton.position).to(equal(position))
        }
      }
      
      context("didEnter") {
        it("should add pause ButtonNode to gameScene.camera") {
            gameSceneActiveState.didEnter(from: nil)
          expect(gameScene.camera?.childNode(withName: ButtonIdentifier.pause.rawValue)).toNot(beNil())
        }
        
        it("should add timer to gameScene.camera") {
            gameSceneActiveState.didEnter(from: nil)
          expect(gameScene.camera?.childNode(withName: LabelIdentifier.timer.rawValue)).toNot(beNil())
        }
        
        context("from FailState") {
          it("should reset time to zero") {
            gameSceneActiveState.time = 304
            gameSceneActiveState.didEnter(from: GameSceneFailState(gameScene: GameScene()))
            expect(gameSceneActiveState.time.isZero).to(beTrue())
          }
        }
      }
      
      context("willExit") {
        it("should remove pause ButtonNode from gameScene.camera") {
          gameScene.camera?.addChild(ButtonNode())
          gameSceneActiveState.willExit(to: GKState())
          expect(gameScene.camera?.childNode(withName: ButtonIdentifier.pause.rawValue)).to(beNil())
        }
      }
    }
  }
}
