//
//  String+Helper.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 3/11/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import Foundation

extension String {
  func capitalizingFirstLetter() -> String {
    let first = String(characters.prefix(1)).capitalized
    let restOfWord = String(characters.dropFirst())
    return first + restOfWord
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}
