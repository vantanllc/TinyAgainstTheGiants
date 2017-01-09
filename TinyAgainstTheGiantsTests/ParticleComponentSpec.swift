//
//  ParticleComponentTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/8/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class ParticleComponentSpec: QuickSpec {
  override func spec() {
    var particle: ParticleComponent!
    
    describe("ParticleComponent") {
      var effect: SKEmitterNode!
      
      beforeEach {
        effect = SKEmitterNode()
        particle = ParticleComponent(particleEffect: effect)
      }
      
      it("should have a SKEmitterNode") {
        expect(particle.particleEffect).to(be(effect))
      }
      
      it("should default has particle effect to false") {
        expect(particle.entityHasParticleEffect).to(beFalse())
      }
    }
  }
}
