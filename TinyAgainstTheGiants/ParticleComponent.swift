//
//  ParticleComponent.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/8/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class ParticleComponent: GKComponent {
  // MARK: Lifecycle
  init(particleEffect: SKEmitterNode) {
    self.particleEffect = particleEffect
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  var entityHasParticleEffect = false
  let particleEffect: SKEmitterNode
}
