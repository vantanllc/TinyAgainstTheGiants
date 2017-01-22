//
//  GameViewController+GameSceneDelegateSpec.swift
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
//class GameViewControllerGameSceneDelegateSpec: QuickSpec {
//  override func spec() {
//    describe("GameViewController+GameSceneDelegate") {
//      var controller: GameViewController!
//      
//      beforeEach {
//        controller = GameViewController()
//      }
//      
//      it("should set gameScene delegate to self") {
//        controller.viewDidLoad()
//        expect(controller.gameScene.gameSceneDelegate).to(be(controller))
//      }
//      
//      context("didEnteredFailState") {
//        var interstitial: MockGADInterstitial!
//        beforeEach {
//          interstitial = MockGADInterstitial(adUnitID: "test")
//          controller.interstitial = interstitial
//          controller.didEnteredFailState()
//        }
//        
//        it("should present interstitial") {
//          expect(interstitial.didCalledPresent).to(beTrue())
//        }
//        
//        it("should present from controller") {
//          expect(interstitial.rootViewController).to(be(controller))
//        }
//      }
//    }
//  }
//  
//  class MockGADInterstitial: GADInterstitial {
//    override func present(fromRootViewController rootViewController: UIViewController) {
//      didCalledPresent = true
//      self.rootViewController = rootViewController
//    }
//    
//    override var isReady: Bool {
//      get {
//        return true
//      }
//    }
//    
//    var didCalledPresent = false
//    var rootViewController: UIViewController?
//  }
//}
