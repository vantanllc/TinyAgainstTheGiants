//
//  MoveComponent.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/5/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class MoveComponent: GKAgent2D {
  // MARK: Lifecycle
  init(maxSpeed: Float, maxAcceleration: Float, radius: Float, mass: Float, entityManager: EntityManager? = nil) {
    self.entityManager = entityManager
    super.init()
    
    self.maxSpeed = maxSpeed
    self.maxAcceleration = maxAcceleration
    self.radius = radius
    self.mass = mass
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  var entityManager: EntityManager?
}
