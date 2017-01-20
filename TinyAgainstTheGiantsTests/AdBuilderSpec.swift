//
//  AdBuilderSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/19/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GoogleMobileAds

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class AdBuilderSpec: QuickSpec {
  override func spec() {
    describe("AdBuilder") {
      context("getInterstitial(forViewController)") {
        var interstitial: GADInterstitial!
        var controller: GADInterstitialDelegate!
        
        beforeEach {
          controller = GameViewController()
          interstitial = AdBuilder.getInterstitial(withDelegate: controller)
        }
        
        it("should set delegate") {
          expect(interstitial.delegate).to(be(controller))
        }
        
        it("should set adUnitID") {
          expect(interstitial.adUnitID).to(equal(AdMob.adUnitID))
        }
      }
    }
  }
}
