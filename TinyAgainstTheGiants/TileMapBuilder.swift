//
//  TileMapBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/1/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class TileMapBuilder {
  static func createFilledTileMapWithTileSet(_ tileSet: SKTileSet, columns: Int, rows: Int) -> SKTileMapNode? {
    guard let tileGroup = tileSet.tileGroups.first else {
      return nil
    }
    
    let tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSet.defaultTileSize, fillWith: tileGroup)
    tileMap.enableAutomapping = false
    return tileMap
  }
  
  static func createTileMapWithNoiseMap(_ noiseMap: GKNoiseMap, withTileSet tileSet: SKTileSet, columns: Int, rows: Int, threshold: Float = 0.5) -> SKTileMapNode? {
    guard let tileGroup = tileSet.tileGroups.first else {
      return nil
    }
    
    let tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSet.defaultTileSize)
    tileMap.enableAutomapping = true
    
    for column in 0..<columns {
      for row in 0..<rows {
        let vector = vector_int2(Int32(column), Int32(row))
        if noiseMap.value(at: vector) >= threshold {
          tileMap.setTileGroup(tileGroup, forColumn: column, row: row)
        }
      }
    }
    
    return tileMap
  }
}
