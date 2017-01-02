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
