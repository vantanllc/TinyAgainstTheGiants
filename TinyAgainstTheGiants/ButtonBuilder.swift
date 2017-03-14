//
//  ButtonBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/15/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import SpriteKit

class ButtonBuilder {
  static func createButton(withIdentifier identifier: ButtonIdentifier) -> ButtonNode {
    let imageName = identifier.rawValue.capitalizingFirstLetter()
    let button = ButtonNode(imageNamed: imageName)
    button.zPosition = NodeLayerPosition.button
    button.name = identifier.rawValue
    button.isUserInteractionEnabled = true
    return button
  }
}
