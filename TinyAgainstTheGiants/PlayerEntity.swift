//
//  PlayerEntity.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

class PlayerEntity: GKEntity {
  // MARK: Lifcycle
  init(node: SKSpriteNode) {
    super.init()
    
    let renderComponent = RenderComponent()
    addComponent(renderComponent)
    
    let spriteComponent = SpriteComponent(node: node)
    addComponent(spriteComponent)
    
    renderComponent.node.addChild(spriteComponent.node)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
