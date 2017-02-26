//
//  DateFormatterHelperSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 2/26/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class DateFormatterHelperSpec: QuickSpec {
  override func spec() {
    describe("DateFormatterHelper") {
      context("getMinuteSecondStyleText") {
        var time: TimeInterval!
        
        it("should return expected text for seconds") {
          time = 33
          expect(DateFormatterHelper.getMinuteSecondStyleText(time: time)).to(equal("0:33"))
        }
        
        it("should return expected text for minute seconds") {
          time = 111
          expect(DateFormatterHelper.getMinuteSecondStyleText(time: time)).to(equal("1:51"))
        }
        
        it("should return expected text for negative seconds") {
          time = -20
          expect(DateFormatterHelper.getMinuteSecondStyleText(time: time)).to(equal("0:00"))
        }
      }
    }
  }
}
