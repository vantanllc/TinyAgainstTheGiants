//
//  RenderComponent.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

class RenderComponent: GKComponent {  
  // MARK: Override Functions
  override func didAddToEntity() {
    node.entity = entity
  }
  
  override func willRemoveFromEntity() {
    node.entity = nil
  }

  // MARK: Properties
  let node = SKNode()
}
