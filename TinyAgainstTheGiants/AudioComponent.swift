//
//  AudioComponent.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 3/13/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

class AudioComponent: GKComponent {
  // MARK: Lifecycle
  init(node: SKAudioNode) {
    self.node = node
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let node: SKAudioNode
}
