//
//  ChargeBarNode.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/8/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import SpriteKit

class ChargeBarNode: SKSpriteNode {
  // MARK: Lifecycle
  init() {
    super.init(texture: nil, color: Configuration.backgroundColor, size: Configuration.size)
    
    addChild(chargeLevelNode)
    
    let xRange = SKRange(constantValue: chargeLevelNode.size.width / -2.0)
    let yRange = SKRange(constantValue: 0.0)
    
    let constraint = SKConstraint.positionX(xRange, y: yRange)
    constraint.referenceNode = self
    
    chargeLevelNode.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    chargeLevelNode.constraints = [constraint]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  let chargeLevelNode = SKSpriteNode(color: Configuration.chargeLevelColor, size: Configuration.chargeLevelNodeSize)
  
  var level: Double = 1 {
    didSet {
      let action = SKAction.scaleX(to: CGFloat(level), duration: Configuration.levelUpdateDuration)
      action.timingMode = .easeInEaseOut
      chargeLevelNode.run(action)
    }
  }
  
}

// MARK: Configuration 
extension ChargeBarNode {
  struct Configuration {
    static let size = CGSize(width: 70.0, height: 6.0)
    
    static let chargeLevelNodeSize = CGSize(width: 70.0, height: 6.0)
    
    static let levelUpdateDuration: TimeInterval = 0.1
    
    static let backgroundColor = SKColor.red
    
    static let chargeLevelColor = SKColor.green
  }
}
