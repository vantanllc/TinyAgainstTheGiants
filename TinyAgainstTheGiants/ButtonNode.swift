//
//  ButtonNode.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/12/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import SpriteKit
import AVFoundation

protocol ButtonRespondable {
  func buttonTriggered(button: ButtonNode)
}

enum ButtonIdentifier: String {
  case retry, pause, resume, start
  case credits
  case musicOn, musicOff
  static let all: [ButtonIdentifier] = [
    .retry, .pause, .resume, .start, .credits, musicOn, musicOff
  ]
}

class ButtonNode: SKSpriteNode {
  // MARK: Properties
  var buttonIdentifier: ButtonIdentifier? {
    var identifier: ButtonIdentifier?
    if let name = name {
      identifier = ButtonIdentifier(rawValue: name)
    }
    return identifier
  }
  
  var responder: ButtonRespondable? {
    guard let responder = scene as? ButtonRespondable else {
      return nil
    }
    return responder
  }
}

// MARK: Functions
extension ButtonNode {
  func buttonTriggered() {
    if isUserInteractionEnabled {
      responder?.buttonTriggered(button: self)
    }
  }
}

// MARK: Touch handling
extension ButtonNode {
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    
    if containsTouches(touches: touches) {
      buttonTriggered()
    }
  }
  
  private func containsTouches(touches: Set<UITouch>) -> Bool {
    guard let scene = scene else {
      fatalError("Button must be used within a SKScene")
    }
    
    return touches.contains { touch in
      let touchPoint = touch.location(in: scene)
      let touchNode = scene.atPoint(touchPoint)
      return touchNode === self || touchNode.inParentHierarchy(self)
    }
  }
}
