//
//  ButtonBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/15/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import SpriteKit

class ButtonBuilder {
  static func getRetryButton() -> ButtonNode {
    let button = ButtonNode(imageNamed: "PlayAgain")
    button.zPosition = NodeLayerPosition.button
    button.name = ButtonIdentifier.retry.rawValue
    button.isUserInteractionEnabled = true
    return button
  }
}
