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
  
  static func getResumeButton() -> ButtonNode {
    let button = ButtonNode(imageNamed: "Resume")
    button.zPosition = NodeLayerPosition.button
    button.name = ButtonIdentifier.resume.rawValue
    button.isUserInteractionEnabled = true
    return button
  }
  
  static func getPauseButton() -> ButtonNode {
    let button = ButtonNode(imageNamed: "Pause")
    button.zPosition = NodeLayerPosition.button
    button.name = ButtonIdentifier.pause.rawValue
    button.isUserInteractionEnabled = true
    return button
  }
}
