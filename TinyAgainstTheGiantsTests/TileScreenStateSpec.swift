//
//  TileScreenStateSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 2/11/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class TitleScreenStateSpec: QuickSpec {
  override func spec() {
    describe("TitleScreenState") {
      var titleScreenState: TitleScreenState!
      var gameScene: GameScene!

      beforeEach {
        gameScene = GameScene()
        titleScreenState = TitleScreenState(gameScene: gameScene)
      }
      
      it("should have gameScene") {
        expect(titleScreenState.gameScene).to(be(gameScene))
      }
      
      context("didEnter") {
        it("should add start button to camera") {
          titleScreenState.didEnter(from: nil)
          expect(gameScene.camera?.childNode(withName: ButtonIdentifier.start.rawValue)).toNot(beNil())
        }
      }
      
      context("willExit") {
        it("should remove start button from camera") {
          let startButton = ButtonBuilder.getStartButton()
          gameScene.camera?.addChild(startButton)
          titleScreenState.willExit(to: GKState())
          expect(gameScene.camera?.childNode(withName: ButtonIdentifier.start.rawValue)).to(beNil())
        }
      }
      
    }
  }
}
