//
//  TileMapBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/1/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class TileMapBuilder {
  static func createFilledTileMapWithTileSet(_ tileSet: SKTileSet, columns: Int, rows: Int) -> SKTileMapNode {
    let tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSet.defaultTileSize, fillWith: tileSet.tileGroups.first!)
    return tileMap
  }
}
