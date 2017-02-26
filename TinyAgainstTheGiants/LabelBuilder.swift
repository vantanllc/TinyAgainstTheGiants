//
//  LabelBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 2/26/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import SpriteKit

class LabelBuilder {
  static func createTimerLabel() -> SKLabelNode {
    let timerNode = SKLabelNode()
    timerNode.fontName = Default.fontName
    timerNode.name = LabelIdentifier.timer.rawValue
    timerNode.zPosition = Default.zPosition
    timerNode.horizontalAlignmentMode = Default.horizontalAlignmentMode
    timerNode.verticalAlignmentMode = Default.verticalAlignmentMode
    timerNode.fontSize = Default.fontSize
    return timerNode
  }
}

extension LabelBuilder {
  struct Default {
    static let fontName = "AmericanTypewriter-Bold"
    static let zPosition = NodeLayerPosition.label
    static let horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .center
    static let verticalAlignmentMode: SKLabelVerticalAlignmentMode = .top
    static let fontSize: CGFloat = 50
  }
}
