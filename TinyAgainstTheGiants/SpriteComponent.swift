//
//  SpriteComponent.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

class SpriteComponent: GKComponent {
  // MARK: Lifecycle
  init(node: SKSpriteNode) {
    self.node = node
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let node: SKSpriteNode
}
