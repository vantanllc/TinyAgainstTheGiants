//
//  GameScene+Credits.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 2/22/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import Foundation
import SCLAlertView

extension GameScene {
  struct Credits {
    static let title = "Credits"
    static let subTitle = "TinyGiants give thanks to the following!"
    static let ludicArt = "Original artwork from Ludicarts"
    static let openClipArt = "Modified artwork from OpenClipArt"
    static let completeAttributions = [ludicArt, openClipArt]
  }
  
  func showCredits() {
      let alert = SCLAlertView()
      let textView = alert.addTextView()
      textView.adjustsFontForContentSizeCategory = true
      textView.isEditable = false
      textView.text = Credits.completeAttributions.joined(separator: "\n")
      alert.showInfo(Credits.title, subTitle: Credits.subTitle)
  }
}
