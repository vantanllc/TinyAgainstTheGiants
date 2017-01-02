//
//  TileMapBuilderSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/1/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class TileMapBuilderSpec: QuickSpec {
  override func spec() {
    describe("TileMapBuilder") {
      let expectedColumns = 9
      let expectedRows = 10
      let expectedSize = CGSize(width: 100, height: 100)
      var tileSet: SKTileSet!
      var tileGroup: SKTileGroup!
      var tileMap: SKTileMapNode!
      
      beforeEach {
        let texture = SKTexture(noiseWithSmoothness: 1.0, size: expectedSize, grayscale: true)
        let tileDefinition = SKTileDefinition(texture: texture)
        tileGroup = SKTileGroup(tileDefinition: tileDefinition)
      }
      
      describe("createTileMapWithNoiseMap") {
        
        context("tileSet with tileGroup") {
          beforeEach {
            tileSet = SKTileSet(tileGroups: [tileGroup])
            tileMap = TileMapBuilder.createTileMapWithNoiseMap(GKNoiseMap(), withTileSet: tileSet, columns: expectedColumns, rows: expectedRows)
          }
          
          it("should return tilemap with automapping enabled") {
            expect(tileMap.enableAutomapping).to(beTrue())
          }
          
          it("should return tilemap with expected column") {
            expect(tileMap.numberOfColumns).to(equal(expectedColumns))
          }
          
          it("should return tilemap with expected row") {
            expect(tileMap.numberOfRows).to(equal(expectedRows))
          }
          
          it("should return tilemap with expected tileSize") {
            expect(tileMap.tileSize).to(equal(expectedSize))
          }
        }
        
        context("tileSet without tileGroup") {
          it("should return nil") {
            tileSet = SKTileSet()
            tileMap = TileMapBuilder.createTileMapWithNoiseMap(GKNoiseMap(), withTileSet: tileSet, columns: expectedColumns, rows: expectedRows)
            expect(tileMap).to(beNil())
          }
        }
      }
      
      describe("createFilledTileMapWithTileSet") {
        context("tileSet without tileGroup") {
          it("should return nil") {
            tileSet = SKTileSet()
            tileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: expectedColumns, rows: expectedRows)
            expect(tileMap).to(beNil())
          }
        }
        
        context("tileSet with tileGroup") {
          beforeEach {
            tileSet = SKTileSet(tileGroups: [tileGroup])
            tileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: expectedColumns, rows: expectedRows)
          }
          
          it("should return tilemap with automapping disable") {
            expect(tileMap.enableAutomapping).to(beFalse())
          }
          
          it("should return tilemap with expected column") {
            expect(tileMap.numberOfColumns).to(equal(expectedColumns))
          }
          
          it("should return tilemap with expected row") {
            expect(tileMap.numberOfRows).to(equal(expectedRows))
          }
          
          it("should return tilemap with expected tileSize") {
            expect(tileMap.tileSize).to(equal(expectedSize))
          }
          
          it("should return tilemap filled with expected tileGroup") {
            for column in 0..<tileMap.numberOfColumns {
              for row in 0..<tileMap.numberOfRows {
                expect(tileMap.tileGroup(atColumn: column, row: row)).to(equal(tileGroup))
              }
            }
          }
        }
      }
    }
  }
}
