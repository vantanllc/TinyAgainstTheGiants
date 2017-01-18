//
//  CameraBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/1/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class CameraBuilder {
  static func constraintCamera(_ camera: SKCameraNode, toSpriteNode node: SKSpriteNode) {
    let constraint = createCameraConstraintToCenterOnSpriteNode(node)
    addContraints([constraint], toCamera: camera)
  }
  
  static func constraintCamera(_ camera: SKCameraNode, toTileMapEdges tileMap: SKTileMapNode, inScene scene: SKScene, withInset inset: CGFloat = 100) {
    let scaledSize = CGSize(width: scene.size.width * camera.xScale, height: scene.size.height * camera.yScale)
    let xLowerLimit = scaledSize.width / 2 - inset
    let xUpperLimit = tileMap.mapSize.width - scaledSize.width / 2 + inset
    let xRange = SKRange(lowerLimit: xLowerLimit, upperLimit: xUpperLimit)
    
    let yUpperLimit = (tileMap.position.y - scaledSize.height / 2) + inset
    let yRange = SKRange(upperLimit: yUpperLimit)
    let edgeContraint = SKConstraint.positionX(xRange, y: yRange)
    
    addContraints([edgeContraint], toCamera: camera)
  }
  
  static func createCameraConstraintToCenterOnSpriteNode(_ node: SKSpriteNode) -> SKConstraint {
    let rangeOfZero = SKRange(constantValue: 0)
    let constraint = SKConstraint.distance(rangeOfZero, to: node)
    return constraint
  }
  
  static func addContraints(_ constraints: [SKConstraint], toCamera camera: SKCameraNode) {
    if let currentConstraints = camera.constraints {
      camera.constraints = currentConstraints + constraints
    } else {
      camera.constraints = constraints
    }
  }
  
  static func addCamera(_ camera: SKCameraNode, toScene scene: SKScene) {
    scene.camera = camera
    scene.addChild(camera)
  }
}
