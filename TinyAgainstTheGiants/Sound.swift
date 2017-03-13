//
//  Sound.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 3/9/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import AVFoundation

class Sound {
  // MARK: Singleton, shared instance
  static let current = Sound()
  
  // MARK: Builder Functions
  static func getBackgroundAudioPlayer() -> AVAudioPlayer? {
    let player = Sound.getAudioPlayer(forResource: AudioFile.background, ofType: FileType.caf)
    player?.numberOfLoops = -1
    return player
  }
  
  static func getAudioPlayer(forResource resource: String, ofType type: String) -> AVAudioPlayer? {
    let path = Bundle.main.path(forResource: resource, ofType: type)!
    let url = URL(fileURLWithPath: path)
    
    do {
      let player = try AVAudioPlayer(contentsOf: url)
      return player
    } catch {
      print("Unable to load audio file")
      return nil
    }
    
  }
  
  // MARK: Properties
  var isEnabled = true
}

extension Sound {
  struct FileType {
    static let caf = "caf"
  }
  
  struct AudioFile {
    static let background = "TinyAgainstTheGiantsBackground"
    static let button = "TinyAgainstTheGiantsButtonSound"
  }
}
