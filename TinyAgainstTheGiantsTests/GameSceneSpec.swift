//
//  GameSceneTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class GameSceneSpec: QuickSpec {
  override func spec() {
    var gameScene: GameScene!
    
    describe("GameScene") {
      beforeEach {
        gameScene = GameScene()
      }
      
      describe("StateMachine") {
        beforeEach {
          gameScene.timerNode = SKLabelNode()
        }
        
        it("should define stateMachine") {
          expect(gameScene.stateMachine).toNot(beNil())
        }
        
        it("should default to GameSceneActiveState") {
          expect(gameScene.stateMachine.currentState).to(beAKindOf(GameSceneActiveState.self))
        }
        
        it("should contain ActiveState") {
          expect(gameScene.stateMachine.state(forClass: GameSceneActiveState.self)).toNot(beNil())
        }
        
        it("should contain FailState") {
          expect(gameScene.stateMachine.state(forClass: GameSceneFailState.self)).toNot(beNil())
        }
        
        context("ActiveState") {
          it("should update timerNode text after update loop") {
            var seconds: TimeInterval = 1
            gameScene.update(seconds)
            let oldTime = gameScene.timerNode.text
            seconds += 1
            gameScene.update(seconds)
            expect(gameScene.timerNode.text).toNot(equal(oldTime))
          }
        }
      }
      
      describe("Displays") {
        context("timerNode") {
          beforeEach {
            gameScene.didMove(to: SKView())
          }
          
          it("should be a child of camera node") {
            expect(gameScene.camera?.children).to(contain(gameScene.timerNode))
          }
          
          it("should be center align") {
            expect(gameScene.timerNode.horizontalAlignmentMode).to(equal(SKLabelHorizontalAlignmentMode.center))
          }
          
          it("should be top align") {
            expect(gameScene.timerNode.verticalAlignmentMode).to(equal(SKLabelVerticalAlignmentMode.top))
          }
          
          it("should have fontSize 50") {
            expect(gameScene.timerNode.fontSize).to(equal(50))
          }
          
          it("should have expected position") {
            let yPosition = gameScene.size.height / 2 - gameScene.timerNode.frame.size.height / 2
            expect(gameScene.timerNode.position.y).to(equal(yPosition))
          }
          
          it("should have zPosition of NodeLayerPosition.label") {
            expect(gameScene.timerNode.zPosition).to(equal(NodeLayerPosition.label))
          }
        }
      }
      
      describe("Game Flow") {
        context("pause") {
          beforeEach {
            gameScene.worldNode.isPaused = false
            gameScene.physicsWorld.speed = 1.0
            gameScene.pause()
          }
          
          it("should pause the worldNode") {
            expect(gameScene.worldNode.isPaused).to(beTrue())
          }
          
          it("should set the physicsWorld speed to zero") {
            expect(gameScene.physicsWorld.speed.isZero).to(beTrue())
          }
        }
        
        context("resume") {
          beforeEach {
            gameScene.worldNode.isPaused = true
            gameScene.physicsWorld.speed = 0
            gameScene.resume()
          }
          
          it("should resume the worldNode") {
            expect(gameScene.worldNode.isPaused).to(beFalse())
          }
          
          it("should set the physicsWorld speed to 1.0") {
            expect(gameScene.physicsWorld.speed).to(equal(1.0))
          }
        }
        
        
      }
      describe("SKPhysicsDelegate") {
        it("should have contactDelegate set to gameScene") {
          expect(gameScene.physicsWorld.contactDelegate).to(be(gameScene))
        }
      }
      
      describe("updateTime") {
        beforeEach {
          gameScene.timerNode = SKLabelNode()
        }
        
        context("when lastUpdateTime is zero") {
          it("should set lastUpdateTime to currentTime") {
            gameScene.lastUpdateTime = 0
            let expectedCurrentTime: TimeInterval = 4
            gameScene.update(expectedCurrentTime)
            
            expect(gameScene.lastUpdateTime).to(equal(expectedCurrentTime))
          }
        }
        
        context("when lastUpdateTime is non-zero") {
          it("should set lastUpdateTime to currentTime") {
            gameScene.lastUpdateTime = 1.2
            let currentTime: TimeInterval = 3
            gameScene.update(currentTime)
            
            expect(gameScene.lastUpdateTime).to(equal(currentTime))
          }
        }
      }
      
      describe("spawn enemies") {
        beforeEach {
          gameScene.timerNode = SKLabelNode()
        }
        
        context("after reaching cooldown time") {
          it("should increment enemyCount by one") {
            let oldEnemyCount = gameScene.enemyCount
            
            gameScene.update(0.1)
            gameScene.update(gameScene.enemySpawnCoolDown + 0.1)
            
            expect(gameScene.enemyCount).to(equal(oldEnemyCount + 1))
          }
          
          it("should reset enemySpawnTime to enemySpawnCoolDown") {
            gameScene.update(0.1)
            gameScene.update(gameScene.enemySpawnCoolDown + 0.1)
            
            expect(gameScene.enemySpawnTime).to(equal(gameScene.enemySpawnCoolDown))
          }
          
          it("should not exceed maxEnemyCount") {
            let maxCount = gameScene.maxEnemyCount
            
            var currentTime: TimeInterval = 0
            gameScene.update(0.1)
            for _ in 0...maxCount {
              currentTime += gameScene.enemySpawnCoolDown + 0.1
              gameScene.update(currentTime)
            }
            
            expect(gameScene.enemyCount).to(equal(maxCount))
          }
        }
      }
      
      describe("adding Entity functions") {
        context("addEnemy") {
          it("should add EnemyEntity render node to worldNode") {
            gameScene.addEnemy()
            if let entity = gameScene.entityManager.getEnemyEntities()?.first, let node = entity.component(ofType: RenderComponent.self)?.node {
              expect(gameScene.worldNode.children).to(contain(node))
            } else {
              fail("Unexpectedly found nil")
            }
          }
          
          it("should increment enemyCount") {
            let expectedCount = 1
            gameScene.addEnemy()
            expect(gameScene.enemyCount).to(equal(expectedCount))
          }
        }
      }
      
      it("should initialize entityManager") {
        expect(gameScene.entityManager).toNot(beNil())
      }
      
      it("should add worldNode to scene") {
        expect(gameScene.children).to(contain(gameScene.worldNode))
      }
      
      context("Player") {        
        it("should add player's RenderComponent node to worldNode") {
          if let expectedPlayerRenderNode = gameScene.entityManager.getPlayerRenderNode() {
            expect(gameScene.worldNode.children).to(contain(expectedPlayerRenderNode))
          } else {
            fail("Unexpectedly got nil.")
          }
        }
      }
      
      it("should add camera to scene") {
        expect(gameScene.camera?.scene).to(be(gameScene))
      }
    }
  }
}
