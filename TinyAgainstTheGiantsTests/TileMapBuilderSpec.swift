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
    describe("createFilledTileMapWithTileSet") {
      let expectedColumns = 10
      let expectedRows = 10
      it("should return tilemap with expected column") {
        let size = CGSize(width: 100, height: 100)
        let texture = SKTexture(noiseWithSmoothness: 1.0, size: size, grayscale: true)
        let tileDefinition = SKTileDefinition(texture: texture)
        let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
        let tileSet = SKTileSet(tileGroups: [tileGroup])
        let tileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: expectedColumns, rows: expectedRows)
        expect(tileMap.tileSize).to(equal(tileSet.defaultTileSize))
      }
      
      it("should return expected filled tilemap") {
        let size = CGSize(width: 100, height: 100)
        let texture = SKTexture(noiseWithSmoothness: 1.0, size: size, grayscale: true)
        let tileDefinition = SKTileDefinition(texture: texture)
        let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
        let tileSet = SKTileSet(tileGroups: [tileGroup])
        let tileMap = TileMapBuilder.createFilledTileMapWithTileSet(tileSet, columns: expectedColumns, rows: expectedRows)
        expect(tileMap.tileSize).to(equal(tileSet.defaultTileSize))
      }
    }
  }
}
