//
//  GameViewController+GameSceneDelegate.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/19/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import Foundation

extension GameViewController: GameSceneDelegate {
  func didEnteredFailState() {
    if interstitial.isReady {
      interstitial.present(fromRootViewController: self)  
    }
  }
}
