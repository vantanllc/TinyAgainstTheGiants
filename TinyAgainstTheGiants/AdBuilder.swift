//
//  AdBuilder.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/19/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GoogleMobileAds

class AdBuilder {
  static func getInterstitial(withDelegate delegate: GADInterstitialDelegate) -> GADInterstitial {
    let interstitial = GADInterstitial(adUnitID: AdMob.adUnitID)
    interstitial.delegate = delegate
    
    let request = GADRequest()
    request.testDevices = [kGADSimulatorID]
    interstitial.load(request)
    
    return interstitial
  }
}
