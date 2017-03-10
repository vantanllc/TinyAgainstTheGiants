//
//  Sound.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 3/9/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import AVFoundation

class Sound {
  static func getBackgroundAudioPlayer() -> AVAudioPlayer? {
    let path = Bundle.main.path(forResource: "TinyAgainstTheGiantsBackground", ofType: "caf")!
    let url = URL(fileURLWithPath: path)
    
    do {
      let player = try AVAudioPlayer(contentsOf: url)
      player.numberOfLoops = -1
      return player
    } catch {
      print("Unable to load audio file")
      return nil
    }
  }
}
