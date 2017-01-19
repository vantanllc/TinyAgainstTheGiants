//
//  AppDelegateSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/18/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class AppDelegateSpec: QuickSpec {
  override func spec() {
    describe("configureAdMob") {
      it("did call after application did finish with options") {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        expect(appDelegate.didConfigureAdMob).to(beTrue())
      }
    }
  }
}
