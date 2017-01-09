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
      
      describe("spawn enemies") {
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
      
      describe("updateObstacleTileMaps") {
        it("should add top edge with tilegroup for updated previousObstacleTileMap") {
          gameScene.updateObstacleTileMaps()
          let topRow = gameScene.previousObstacleTileMap.numberOfRows - 1
          for column in 0..<gameScene.previousObstacleTileMap.numberOfColumns {
            expect(gameScene.previousObstacleTileMap.tileGroup(atColumn: column, row: topRow)).toNot(beNil())
          }
        }
        
        it("should set previousObstacleTileMap to currentObstacleTileMap") {
          let currentObstacleTileMap = gameScene.currentObstacleTileMap
          gameScene.updateObstacleTileMaps()
          expect(gameScene.previousObstacleTileMap).to(be(currentObstacleTileMap))
        }
        
        it("should remove previousObstacleTileMap from worldNode") {
          if let previousObstacleTileMap = gameScene.previousObstacleTileMap {
            gameScene.updateObstacleTileMaps()
            expect(gameScene.worldNode.children).toNot(contain(previousObstacleTileMap))
          } else {
            fail("Unexpectedly found nil")
          }
        }
        
        it("should set currentObstacleTileMap to nextObstacleTileMap") {
          let nextTileMap = gameScene.nextObstacleTileMap
          gameScene.updateObstacleTileMaps()
          expect(gameScene.currentObstacleTileMap).to(be(nextTileMap))
        }
        
        it("should generate a new tile map for nextObstacleTileMap") {
          let oldCurrentTileMap = gameScene.currentObstacleTileMap
          let oldNextTileMap = gameScene.nextObstacleTileMap
          gameScene.updateObstacleTileMaps()
          expect(gameScene.nextObstacleTileMap).toNot((be(oldCurrentTileMap)))
          expect(gameScene.nextObstacleTileMap).toNot((be(oldNextTileMap)))
        }
        
        it("should add new tile for nextObstacleTileMap to worldNode") {
          gameScene.updateObstacleTileMaps()
          expect(gameScene.worldNode.children).to(contain(gameScene.nextObstacleTileMap))
        }
      }
      
      describe("updateBackgroundTileMaps") {
        it("should remove previousBackgroundTileMap from worldNode") {
          if let previousBackgroundTileMap = gameScene.previousBackgroundTileMap {
            gameScene.updateBackgroundTileMaps()
            expect(gameScene.worldNode.children).toNot(contain(previousBackgroundTileMap))
          }
        }
        
        it("should set previousBackgroundTileMap to currentBackgroundTileMap") {
          let currentTileMap = gameScene.currentBackgroundTileMap
          gameScene.updateBackgroundTileMaps()
          expect(gameScene.previousBackgroundTileMap).to(be(currentTileMap))
        }
        
        it("should set currentBackgroundTileMap to nextBackgroundTileMap") {
          let nextTileMap = gameScene.nextBackgroundTileMap
          gameScene.updateBackgroundTileMaps()
          expect(gameScene.currentBackgroundTileMap).to(be(nextTileMap))
        }
        
        it("should generate a new tile map for nextBackgroundTileMap") {
          let oldCurrentTileMap = gameScene.currentBackgroundTileMap
          let oldNextTileMap = gameScene.nextBackgroundTileMap
          gameScene.updateBackgroundTileMaps()
          expect(gameScene.nextBackgroundTileMap).toNot((be(oldCurrentTileMap)))
          expect(gameScene.nextBackgroundTileMap).toNot((be(oldNextTileMap)))
        }
        
        it("should add new tile for nextBackgroundTileMap to worldNode") {
          gameScene.updateBackgroundTileMaps()
          expect(gameScene.worldNode.children).to(contain(gameScene.nextBackgroundTileMap))
        }
      }
      
      it("should initialize entityManager") {
        expect(gameScene.entityManager).toNot(beNil())
      }
      
      it("should add worldNode to scene") {
        expect(gameScene.children).to(contain(gameScene.worldNode))
      }
      
      context("BackgroundTileMaps") {
        it("should add previousBackgroundTileMap to worldNode") {
          expect(gameScene.previousBackgroundTileMap.parent).to(be(gameScene.worldNode))
        }
        
        it("should set previousBackgroundTileMap y position above currentBackgroundTileMap") {
          let expectedYPosition = gameScene.previousBackgroundTileMap.mapSize.height + gameScene.currentBackgroundTileMap.frame.maxY
          expect(gameScene.previousBackgroundTileMap.position.y).to(equal(expectedYPosition))
        }
        
        it("should add currentBackgroundTileMap to worldNode") {
          expect(gameScene.currentBackgroundTileMap.parent).to(be(gameScene.worldNode))
        }
        
        it("should add nextBackgroundTileMap to worldNode") {
          expect(gameScene.nextBackgroundTileMap.parent).to(be(gameScene.worldNode))
        }
        
        it("should position nextBackgroundTileMap below currentBackgroundTileMap") {
          let expectedPosition = CGPoint(x: gameScene.currentBackgroundTileMap.frame.minX, y: gameScene.currentBackgroundTileMap.frame.minY)
          expect(gameScene.nextBackgroundTileMap.position).to(equal(expectedPosition))
        }
        
        context("NodeLayerPosition") {
          it("should be .background") {
            let zPositions = [gameScene.previousBackgroundTileMap.zPosition, gameScene.currentBackgroundTileMap.zPosition, gameScene.nextBackgroundTileMap.zPosition]
            expect(zPositions).to(allPass(equal(NodeLayerPosition.background)))
          }
        }
      }

      context("ObstacleTileMap") {
        it("should add previousObstacleTileMap to worldNode") {
          expect(gameScene.previousObstacleTileMap.parent).to(be(gameScene.worldNode))
        }
        
        it("should set previousObstacleTileMap y position above currentObstacleTileMap") {
          let expectedYPosition = gameScene.previousObstacleTileMap.mapSize.height + gameScene.previousObstacleTileMap.frame.minY
          expect(gameScene.previousObstacleTileMap.position.y).to(equal(expectedYPosition))
        }
        
        it("should add currentObstacleTileMap to worldNode") {
          expect(gameScene.currentObstacleTileMap.parent).to(be(gameScene.worldNode))
        }
        
        it("should add nextObstacleTileMap to worldNode") {
          expect(gameScene.nextObstacleTileMap.parent).to(be(gameScene.worldNode))
        }
        
        it("should position nextObstacleTileMap below currentBackgroundTileMap") {
          let expectedPosition = CGPoint(x: gameScene.currentObstacleTileMap.frame.minX, y: gameScene.currentObstacleTileMap.frame.minY)
          expect(gameScene.nextObstacleTileMap.position).to(equal(expectedPosition))
        }
        
        it("should add nextObstacleTileMap with edged tilegroups") {
          let lastColumn = gameScene.nextObstacleTileMap.numberOfColumns - 1
          let lastRow = gameScene.nextObstacleTileMap.numberOfRows - 1
          for column in [0, lastColumn] {
            for row in 0...lastRow {
              expect(gameScene.nextObstacleTileMap.tileGroup(atColumn: column, row: row)).toNot(beNil())
            }
          }
        }
        
        context("NodeLayerPosition") {
          it("should be .obstacle") {
            let zPositions = [gameScene.previousObstacleTileMap.zPosition, gameScene.currentObstacleTileMap.zPosition, gameScene.nextObstacleTileMap.zPosition]
            expect(zPositions).to(allPass(equal(NodeLayerPosition.obstacle)))
          }
        }
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
