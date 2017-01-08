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

// MARK: Update
extension MoveComponent {
  override func update(deltaTime seconds: TimeInterval) {
    super.update(deltaTime: seconds)
    
    guard let team = entity?.component(ofType: TeamComponent.self)?.team, let entityManager = entityManager else {
      return
    }
    
    let opposingTeamMoveComponents = entityManager.getMoveComponentsForTeam(team.oppositeTeam())
    if let closestMoveComponent = getClosestFromMoveComponents(opposingTeamMoveComponents) {
      let sameTeamMoveComponents = entityManager.getMoveComponentsForTeam(team)
      behavior = MoveBehavior(targetSpeed: maxSpeed, seek: closestMoveComponent, avoid: sameTeamMoveComponents)
    }
  }
}

// MARK: Filtering Functions
extension MoveComponent {
  func getClosestFromMoveComponents(_ moveComponents: [MoveComponent]) -> MoveComponent? {
    var closestMoveComponent: MoveComponent?
    var closestDistance = CGFloat(0)
    for moveComponent in moveComponents {
      let distance = (CGPoint(moveComponent.position) - CGPoint(position)).length()
      if closestMoveComponent == nil || distance < closestDistance {
        closestMoveComponent = moveComponent
        closestDistance = distance
      }
    }
    
    return closestMoveComponent
  }
}
