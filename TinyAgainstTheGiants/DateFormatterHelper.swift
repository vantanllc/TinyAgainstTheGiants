//
//  DateFormatter.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 2/25/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import Foundation

class DateFormatterHelper {
  static let minuteSecondFormat: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    
    return formatter
  }()
  
  static func getMinuteSecondStyleText(time: TimeInterval) -> String {
      var components = DateComponents()
      components.second = Int(max(0.0, time))
      return DateFormatterHelper.minuteSecondFormat.string(from: components)!
  }
}
