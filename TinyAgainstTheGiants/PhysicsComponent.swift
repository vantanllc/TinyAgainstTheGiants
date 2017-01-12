//
//  PhysicsComponent.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/2/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class PhysicsComponent: GKComponent {
  // MARK: Lifecycle
  init(physicsBody: SKPhysicsBody, colliderType: ColliderType) {
    self.physicsBody = physicsBody
    super.init()
    
    physicsBody.categoryBitMask = colliderType.categoryMask
    physicsBody.collisionBitMask = colliderType.collisionMask
    physicsBody.contactTestBitMask = colliderType.contactMask
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  var physicsBody: SKPhysicsBody
}
