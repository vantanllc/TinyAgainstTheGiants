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
          gameScene.didMove(to: SKView())
        }
        
        it("should define stateMachine") {
          expect(gameScene.stateMachine).toNot(beNil())
        }
        
        it("should default to GameSceneActiveState") {
          expect(gameScene.stateMachine.currentState).to(beAKindOf(TitleScreenState.self))
        }
        
        it("should contain TitleScreenState") {
          expect(gameScene.stateMachine.state(forClass: TitleScreenState.self)).toNot(beNil())
        }
        
        it("should contain ActiveState") {
          expect(gameScene.stateMachine.state(forClass: GameSceneActiveState.self)).toNot(beNil())
        }
        
        it("should contain FailState") {
          expect(gameScene.stateMachine.state(forClass: GameSceneFailState.self)).toNot(beNil())
        }
        
        it("should contain PauseState") {
          expect(gameScene.stateMachine.state(forClass: GameScenePauseState.self)).toNot(beNil())
        }
      }
      
      describe("Displays") {
        context("didChangeSize") {
          it("should re-position timerNode") {
            let timer = SKLabelNode(text: "testing")
            timer.name = LabelIdentifier.timer.rawValue
            timer.fontSize = 50
            timer.position = CGPoint(x: 0, y: 200)
            gameScene.camera?.addChild(timer)
            gameScene.size = CGSize(width: 400, height: 400)
            let yPosition = gameScene.size.height / 2 - timer.frame.size.height / 2
            expect(timer.position.y).to(equal(yPosition))
          }
          
          it("should re-position pauseButton") {
            let pauseButton = ButtonBuilder.getPauseButton()
            pauseButton.position = CGPoint(x: 600, y: 300)
            gameScene.camera?.addChild(pauseButton)
            gameScene.size = CGSize(width: 400, height: 400)
            let expectPosition = CGPoint(x: gameScene.size.width * 0.5, y: -gameScene.size.height * 0.5)
            expect(pauseButton.position).to(equal(expectPosition))
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
            expect(gameScene.entityManager.getEnemyEntities()!.count).to(equal(expectedCount))
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
          gameScene.startNewGame()
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
