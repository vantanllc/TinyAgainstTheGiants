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
      let expectedAnchorPoint = CGPoint(x: 0, y: 1)
      let trialCount = stride(from: 1, to: 10, by: 1)
      let threshold: Float = 0.5
      let noiseMap = NoiseMapBuilder.getPerlinNoiseMap(frequency: 10)
      let expectedColumns = 300
      let expectedRows = 200
      let expectedSize = CGSize(width: 100, height: 100)
      var tileSet: SKTileSet!
      var tileGroup: SKTileGroup!
      var tileMap: SKTileMapNode!
      
      beforeEach {
        let texture = SKTexture(noiseWithSmoothness: 1.0, size: expectedSize, grayscale: true)
        let tileDefinition = SKTileDefinition(texture: texture)
        tileGroup = SKTileGroup(tileDefinition: tileDefinition)
      }
      
      describe("addTopEdgeToTileMap") {
        context("tileSet with TileGroup") {
          it("should fill tilemap with tilegroup along the top edge") {
            tileSet = SKTileSet(tileGroups: [tileGroup])
            tileMap = SKTileMapNode(tileSet: tileSet, columns: expectedColumns, rows: expectedRows, tileSize: tileSet.defaultTileSize)
            
            TileMapBuilder.addTopEdgeToTileMap(tileMap)
            
            let topRow = expectedRows - 1
            for column in 0..<expectedColumns {
              expect(tileMap.tileGroup(atColumn: column, row: topRow)).to(equal(tileGroup))
            }
          }
        }
        
        context("tileSet without TileGroup") {
          it("should not fill tilemap with tilegroup along the top edge") {
            tileSet = SKTileSet()
            tileMap = SKTileMapNode(tileSet: tileSet, columns: expectedColumns, rows: expectedRows, tileSize: tileSet.defaultTileSize)
            
            TileMapBuilder.addTopEdgeToTileMap(tileMap)
            
            var tileGroups = [SKTileGroup]()
            let topRow = expectedRows - 1
            for column in 0..<expectedColumns {
              if let tileGroup = tileMap.tileGroup(atColumn: column, row: topRow) {
                tileGroups.append(tileGroup)
              }
            }
            
            expect(tileGroups.count).to(beLessThan(expectedColumns))
          }
        }
      }
      
      describe("createEdgedTileMapWithNoiseMap") {
        context("tileSet with TileGroup") {
          beforeEach {
            tileSet = SKTileSet(tileGroups: [tileGroup])
            tileMap = TileMapBuilder.createEdgedTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: expectedColumns, rows: expectedRows)
          }
          
          it("should return tilemap with tilegroup along the side edges") {
            for column in [0, expectedColumns - 1] {
              for row in 0..<expectedRows {
                expect(tileMap.tileGroup(atColumn: column, row: row)).to(equal(tileGroup))
              }
            }
          }
        }
        
        context("tileSet without TileGroup") {
          it("should return nil") {
            tileSet = SKTileSet()
            tileMap = TileMapBuilder.createEdgedTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: expectedColumns, rows: expectedRows)
            expect(tileMap).to(beNil())
          }
        }
      }
      
      describe("createCappedTileMapWithNoiseMap") {
        context("tileSet with TileGroup") {
          beforeEach {
            tileSet = SKTileSet(tileGroups: [tileGroup])
            tileMap = TileMapBuilder.createCappedTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: expectedColumns, rows: expectedRows)
          }
          
          it("should return tilemap with tilegroup along the side edges") {
            for column in [0, expectedColumns - 1] {
              for row in 0..<expectedRows {
                expect(tileMap.tileGroup(atColumn: column, row: row)).to(equal(tileGroup))
              }
            }
          }
          
          it("should return tilemap with tilegroup along the top edge") {
            let topRow = expectedRows - 1
            for column in 0..<expectedColumns {
              expect(tileMap.tileGroup(atColumn: column, row: topRow)).to(equal(tileGroup))
            }
          }
        }
        
        context("tileSet without TileGroup") {
          it("should return nil") {
            tileSet = SKTileSet()
            tileMap = TileMapBuilder.createCappedTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: expectedColumns, rows: expectedRows)
            expect(tileMap).to(beNil())
          }
        }
      }
      
      
      describe("getRandomPositionNotOnTileGroupInTileMap") {
        beforeEach {
          tileSet = SKTileSet(tileGroups: [tileGroup])
        }
        
        context("given a tileMap with only one missing tilegroup") {
          beforeEach {
            tileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: expectedColumns, rows: expectedRows)
            tileMap.setTileGroup(nil, forColumn: 5, row: 9)
          }
          it("should return the same random points") {
            var previousPoint = TileMapBuilder.getRandomPositionNotOnTileGroupInTileMap(tileMap)
            for _ in trialCount {
              let nextPoint = TileMapBuilder.getRandomPositionNotOnTileGroupInTileMap(tileMap)
              expect(nextPoint).to(equal(previousPoint))
              
              previousPoint = nextPoint
            }
          }
          
          it("should return random points not on a tilegroup") {
            for _ in trialCount {
              let nextPoint = TileMapBuilder.getRandomPositionNotOnTileGroupInTileMap(tileMap)
              let column = tileMap.tileColumnIndex(fromPosition: nextPoint)
              let row = tileMap.tileRowIndex(fromPosition: nextPoint)
              expect(tileMap.tileGroup(atColumn: column, row: row)).to(beNil())
            }
          }
        }
        
        context("given a tileMap with many missing tilegroups") {
          beforeEach {
            tileMap = TileMapBuilder.createTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: expectedColumns, rows: expectedRows)

          }
          it("should return random points") {
            var previousPoint = TileMapBuilder.getRandomPositionNotOnTileGroupInTileMap(tileMap)
            for _ in trialCount {
              let nextPoint = TileMapBuilder.getRandomPositionNotOnTileGroupInTileMap(tileMap)
              expect(nextPoint).toNot(equal(previousPoint))
              
              previousPoint = nextPoint
            }
          }
          it("should return random points not on a tilegroup") {
            for _ in trialCount {
              let nextPoint = TileMapBuilder.getRandomPositionNotOnTileGroupInTileMap(tileMap)
              let column = tileMap.tileColumnIndex(fromPosition: nextPoint)
              let row = tileMap.tileRowIndex(fromPosition: nextPoint)
              expect(tileMap.tileGroup(atColumn: column, row: row)).to(beNil())
            }
          }
        }
      }
      
      describe("getRandomPositionInTileMap") {
        context("when given a tilemap with many tilegroup") {
          it("should return random points") {
            tileSet = SKTileSet(tileGroups: [tileGroup])
            tileMap = SKTileMapNode(tileSet: tileSet, columns: expectedColumns, rows: expectedRows, tileSize: tileSet.defaultTileSize)
            
            var previousPoint = TileMapBuilder.getRandomPositionInTileMap(tileMap)
            
            for _ in trialCount {
              let nextPoint = TileMapBuilder.getRandomPositionInTileMap(tileMap)
              expect(nextPoint).toNot(equal(previousPoint))
              
              previousPoint = nextPoint
            }
          }
        }
        
        context("when given a tilemap with one tilegroup") {
          it("should return the same point") {
            tileMap = SKTileMapNode(tileSet: tileSet, columns: 1, rows: 1, tileSize: tileSet.defaultTileSize)
            
            var previousPoint = TileMapBuilder.getRandomPositionInTileMap(tileMap)

            for _ in trialCount {
              let nextPoint = TileMapBuilder.getRandomPositionInTileMap(tileMap)
              expect(nextPoint).to(equal(previousPoint))
              
              previousPoint = nextPoint
            }
          }
        }
      }
      
      describe("createTileMapWithNoiseMap") {
        context("tileSet with tileGroup") {
          beforeEach {
            tileSet = SKTileSet(tileGroups: [tileGroup])
            tileMap = TileMapBuilder.createTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: expectedColumns, rows: expectedRows, threshold: threshold)
          }
          
          it("should return tilemap with tilegroup matching noisemap") {
            for column in 0..<expectedColumns {
              for row in 0..<expectedRows {
                let vector = vector_int2(Int32(column), Int32(row))
                if noiseMap.value(at: vector) >= threshold {
                  expect(tileMap.tileGroup(atColumn: column, row: row)).to(equal(tileGroup))
                } else {
                  expect(tileMap.tileGroup(atColumn: column, row: row)).to(beNil())
                }
              }
            }
          }
          
          it("should return tilemap with expected anchorPoint") {
            expect(tileMap.anchorPoint).to(equal(expectedAnchorPoint))
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
            tileMap = TileMapBuilder.createTileMapWithNoiseMap(noiseMap, withTileSet: tileSet, columns: expectedColumns, rows: expectedRows)
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
          
          it("should return tilemap with expected anchorPoint") {
            expect(tileMap.anchorPoint).to(equal(expectedAnchorPoint))
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
