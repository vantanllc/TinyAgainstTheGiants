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
        gameScene.didMove(to: SKView())
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
