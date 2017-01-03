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
      
      describe("updateObstacleTileMaps") {
        it("should set previousObstacleTileMap to currentObstacleTileMap") {
          let currentTileMap = gameScene.currentObstacleTileMap
          gameScene.updateObstacleTileMaps()
          expect(gameScene.previousObstacleTileMap).to(be(currentTileMap))
        }
        
        it("should set currentObstacleTileMap to nextObstacleTileMap") {
          let nextTileMap = gameScene.nextObstacleTileMap
          gameScene.updateObstacleTileMaps()
          expect(gameScene.currentObstacleTileMap).to(be(nextTileMap))
        }
        
        it("should generate a new tile map for nextObstacleTileMap") {
          let oldCurrentTileMap = gameScene.currentObstacleTileMap.copy()
          let oldNextTileMap = gameScene.nextObstacleTileMap.copy()
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
          let oldCurrentTileMap = gameScene.currentBackgroundTileMap.copy()
          let oldNextTileMap = gameScene.nextBackgroundTileMap.copy()
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
      
      it("should add camera to scene") {
        expect(gameScene.camera?.scene).to(be(gameScene))
      }
      
      it("should add player's RenderComponent node to worldNode") {
        if let expectedPlayerRenderNode = gameScene.entityManager.getPlayerRenderNode() {
          expect(gameScene.worldNode.children).to(contain(expectedPlayerRenderNode))
        } else {
          fail("Unexpectedly got nil.")
        }
      }
    }
  }
}
