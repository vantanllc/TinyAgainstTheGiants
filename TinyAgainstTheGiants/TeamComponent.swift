//
//  TeamComponent.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/5/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

enum Team: Int {
  case One = 1
  case Two = 2
  
  static let allvalues = [One, Two]
  
  func oppositeTeam() -> Team {
    switch self {
    case .One:
      return .Two
    case .Two:
      return .One
      
    }
  }
}

class TeamComponent: GKComponent {
  // MARK: Lifecycle
  init(team: Team) {
    self.team = team
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let team: Team!
}
