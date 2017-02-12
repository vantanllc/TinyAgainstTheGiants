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
        beforeEach {
          gameScene.addBackgroundTileMap()
          titleScreenState.didEnter(from: nil)
        }
        
        it("should add start button to camera") {
          expect(gameScene.camera?.childNode(withName: ButtonIdentifier.start.rawValue)).toNot(beNil())
        }
        
        it("should move camera to position inside background tilemap") {
          let expectedPosition = CGPoint(x: gameScene.currentBackgroundTileMap.frame.midX, y: gameScene.currentBackgroundTileMap.frame.maxY)
          expect(gameScene.camera?.position).to(equal(expectedPosition))
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
