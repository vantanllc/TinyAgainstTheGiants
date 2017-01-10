//
//  ChargeBarComponent.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/9/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class ChargeBarComponent: GKComponent {
  // MARK: Lifecycle
  init(charge: Double, maxCharge: Double, displayChargeBar: Bool = false) {
    self.charge = charge
    self.maxCharge = maxCharge
    
    if displayChargeBar {
      chargeBarNode = ChargeBarNode()
    } else {
      chargeBarNode = nil
    }
    
    super.init()
    
    chargeBarNode?.level = percentage
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Properties
  var charge: Double
  let maxCharge: Double
  let chargeBarNode: ChargeBarNode?
  
  var percentage: Double {
    if maxCharge.isZero {
      return 0
    }
    
    return charge / maxCharge
  }
}

// MARK: Functions
extension ChargeBarComponent {
  func loseCharge(chargeToLose: Double) {
    var newCharge = charge - chargeToLose
    
    newCharge = min(maxCharge, newCharge)
    newCharge = max(0.0, newCharge)
    
    if newCharge < charge {
      charge = newCharge
      chargeBarNode?.level = percentage
    }
  }
  
  func addCharge(chargeToAdd: Double) {
    var newCharge = charge + chargeToAdd
    
    newCharge = min(maxCharge, newCharge)
    newCharge = max(0.0, newCharge)
    
    if newCharge > charge {
      charge = newCharge
      chargeBarNode?.level = percentage
    }
  }
}
