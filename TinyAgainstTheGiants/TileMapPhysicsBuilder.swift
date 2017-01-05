//
//  TileMapPhysicsBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/3/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import SpriteKit

class TileMapPhysicsBuilder {
  
  static func getScaleTransformForTileDefinitionType(_ tileDefinitionType: TileDefinitionType) -> CGAffineTransform {
    let transform: CGAffineTransform
    
    switch tileDefinitionType {
    case .Center:
      transform = CGAffineTransform(scaleX: 1, y: 1)
    case .UpEdge, .DownEdge:
      transform = CGAffineTransform(scaleX: 1, y: 0.5)
    case .LeftEdge, .RightEdge:
      transform = CGAffineTransform(scaleX: 0.5, y: 1)
    case .UpperLeftEdge, .UpperRightEdge, .LowerLeftEdge, .LowerRightEdge:
      transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    default:
      transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    return transform
  }
  
  static func getTranslationTransformForTileDefinitionType(_ tileDefinitionType: TileDefinitionType, withTileSize tileSize: CGSize) -> CGAffineTransform {
    let transform: CGAffineTransform
    
    switch tileDefinitionType {
    case .Center:
      transform = CGAffineTransform(translationX: 0, y: 0)
    case .UpEdge:
      transform = CGAffineTransform(translationX: 0, y: -0.25 * tileSize.height)
    case .DownEdge:
      transform = CGAffineTransform(translationX: 0, y: 0.25 * tileSize.height)
    case .LeftEdge:
      transform = CGAffineTransform(translationX: 0.25 * tileSize.height, y: 0)
    case .RightEdge:
      transform = CGAffineTransform(translationX: -0.25 * tileSize.height, y: 0)
    case .UpperLeftEdge:
      transform = CGAffineTransform(translationX: 0.25 * tileSize.height, y: -0.25 * tileSize.height)
    case .UpperRightEdge:
      transform = CGAffineTransform(translationX: -0.25 * tileSize.height, y: -0.25 * tileSize.height)
    case .LowerLeftEdge:
      transform = CGAffineTransform(translationX: 0.25 * tileSize.height, y: 0.25 * tileSize.height)
    case .LowerRightEdge:
      transform = CGAffineTransform(translationX: -0.25 * tileSize.height, y: 0.25 * tileSize.height)
    default:
      transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    return transform
  }
  
  static func getPhysicsBodyFromTileDefinition(tileDefinition: SKTileDefinition, center: CGPoint) -> SKPhysicsBody? {
    var tileDefinitionPhysicsBody: SKPhysicsBody?
    
    guard let tileDefinitionData = tileDefinition.userData?["tileDefinitionType"] as? String, let tileDefinitionType = TileDefinitionType(rawValue: tileDefinitionData) else {
      return nil
    }
    
    let tileSize = tileDefinition.size
    let scaleTransform = getScaleTransformForTileDefinitionType(tileDefinitionType)
    let translationTransform = getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
    
    tileDefinitionPhysicsBody = SKPhysicsBody(rectangleOf: tileSize.applying(scaleTransform), center: center.applying(translationTransform))
    
    return tileDefinitionPhysicsBody
  }
  
  static func getPhysicsBodiesFromTileMapNode(tileMapNode: SKTileMapNode) -> [SKPhysicsBody] {
    var physicsBodies = [SKPhysicsBody]()
    
    for column in 0..<tileMapNode.numberOfColumns {
      for row in 0..<tileMapNode.numberOfRows {
        if let tileDefinition = tileMapNode.tileDefinition(atColumn: column, row: row) {
          if let physicsBody = getPhysicsBodyFromTileDefinition(tileDefinition: tileDefinition, center: tileMapNode.centerOfTile(atColumn: column, row: row)) {
            physicsBodies.append(physicsBody)
          }
        }
      }
    }
    
    return physicsBodies
  }
}
