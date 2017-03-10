//
//  SoundSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 3/9/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import Quick
import Nimble
import AVFoundation
@testable import TinyAgainstTheGiants

class SoundSpec: QuickSpec {
  override func spec() {
    describe("Sound") {
      context("getBackgroundAudioPlayer") {
        var player: AVAudioPlayer!
        
        beforeEach {
          player = Sound.getBackgroundAudioPlayer()
        }
        it("should have correct background url") {
          let expectedURL = URL(fileURLWithPath: Bundle.main.path(forResource: Sound.AudioFile.background, ofType: Sound.FileType.caf)!)
          expect(player?.url).to(equal(expectedURL))
        }
        
        it("should loop infinitely") {
          expect(player.numberOfLoops).to(beLessThan(0))
        }
      }
    }
  }
}
