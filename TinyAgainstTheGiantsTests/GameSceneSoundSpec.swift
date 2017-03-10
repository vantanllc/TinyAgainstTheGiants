//
//  GameSceneSoundSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 3/9/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import Quick
import Nimble
import AVFoundation
import SpriteKit
@testable import TinyAgainstTheGiants

class GameSceneSoundSpec: QuickSpec {
  override func spec() {
    describe("GameSceneSound") {
      var gameScene: GameScene!
      
      beforeEach {
        gameScene = GameScene()
      }
      
      context("background audio") {
        beforeEach {
          gameScene.didMove(to: SKView())
        }
        it("should be init") {
          expect(gameScene.backgroundAudio).toNot(beNil())
        }
        
        it("should be playing") {
          expect(gameScene.backgroundAudio.isPlaying).to(beTrue())
        }
      }
    }
  }
}
