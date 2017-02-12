//
//  MoveBehavior.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/5/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class MoveBehavior: GKBehavior {
  // MARK: Lifecycle
  init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
    goalToReachTargetSpeed = GKGoal(toReachTargetSpeed: targetSpeed)
    goalToSeekAgent = GKGoal(toSeekAgent: seek)
    goalToAvoidAgents = GKGoal(toAvoid: avoid, maxPredictionTime: maxPredictionTime)
    super.init()
    
    setWeight(0.1, for: goalToReachTargetSpeed)
    setWeight(0.8, for: goalToSeekAgent)
    setWeight(0.3, for: goalToAvoidAgents)
    
  }
  
  // MARK: Properties
  let goalToReachTargetSpeed: GKGoal!
  let goalToSeekAgent: GKGoal!
  let goalToAvoidAgents: GKGoal!
  let maxPredictionTime: TimeInterval = 1
}
