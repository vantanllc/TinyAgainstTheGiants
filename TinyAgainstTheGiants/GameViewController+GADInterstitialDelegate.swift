//
//  GameViewController+GADInterstitialDelegate.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/19/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GoogleMobileAds

extension GameViewController: GADInterstitialDelegate {
  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    interstitial = AdBuilder.getInterstitial(withDelegate: self)
  }
}
