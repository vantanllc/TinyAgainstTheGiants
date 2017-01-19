//
//  AppDelegate.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/30/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: Functions
  func configureAdMob() {
    GADMobileAds.configure(withApplicationID: AdMob.appID)
    didConfigureAdMob = true
  }
  
  // MARK: Launch
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    configureAdMob()
    return true
  }
  
  // MARK: Properties
  var window: UIWindow?
  var didConfigureAdMob = false
}
