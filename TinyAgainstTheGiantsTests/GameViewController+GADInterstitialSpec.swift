//
//  GameViewController+GADInterstitialDelegateSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/19/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

//import GoogleMobileAds
//
//import Quick
//import Nimble
//import SpriteKit
//
//@testable import TinyAgainstTheGiants
//
//class GameViewControllerGADInterstitialSpec: QuickSpec {
//  override func spec() {
//    describe("GameViewController+GADInterstitialSpec") {
//      var controller: GameViewController!
//      
//      beforeEach {
//        controller = GameViewController()
//      }
//      
//      it("should set interstitial after viewDidLoad") {
//        controller.viewDidLoad()
//        expect(controller.interstitial).toNot(beNil())
//      }
//      
//      context("interstitialDidDismissScreen") {
//        it("should create and set new interstitial") {
//          controller.viewDidLoad()
//          let oldInterstitial = controller.interstitial
//          controller.interstitialDidDismissScreen(GADInterstitial(adUnitID: ""))
//          expect(controller.interstitial).toNot(be(oldInterstitial))
//        }
//      }
//    }
//    
//  }
//}
