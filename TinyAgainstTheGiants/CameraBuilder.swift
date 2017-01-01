//
//  CameraBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/1/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class CameraBuilder {
  static func addContraints(_ constraints: [SKConstraint], toCamera camera: SKCameraNode) {
    if let currentConstraints = camera.constraints {
      camera.constraints = currentConstraints + constraints
    } else {
      camera.constraints = constraints
    }
  }
  
  static func addCamera(_ camera: SKCameraNode, toScene scene: SKScene) {
    scene.camera = camera
  }
}
