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
}
