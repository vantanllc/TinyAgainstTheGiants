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
        
        it("should add credits button to camera") {
          expect(titleScreenState.creditsButton.parent).to(be(gameScene.camera))
        }
        
        it("should add start button to camera") {
          expect(titleScreenState.startButton.parent).to(be(gameScene.camera))
        }
        
        it("should add title to camera") {
          expect(titleScreenState.title.parent).to(be(gameScene.camera))
        }
        
        it("should add player to gameScene") {
          expect(gameScene.entityManager.getPlayerEntity()).toNot(beNil())
        }
        
        it("should add camera constraints to follow player") {
          expect(gameScene.camera?.constraints).toNot(beNil())
        }
        
        it("should set expected gravity for gameScene") {
          expect(gameScene.physicsWorld.gravity).to(equal(GameScene.Configuration.gravity))
        }
      }
      
      context("willExit") {
        it("should remove start button from camera") {
          let startButton = ButtonBuilder.createButton(withIdentifier: .start)
          titleScreenState.startButton = startButton
          gameScene.camera?.addChild(startButton)
          titleScreenState.willExit(to: GKState())
          expect(startButton.parent).to(beNil())
        }
        
        it("should remove credits button from camera") {
          let creditsButton = ButtonBuilder.createButton(withIdentifier: .credits)
          titleScreenState.creditsButton = creditsButton 
          gameScene.camera?.addChild(creditsButton)
          titleScreenState.willExit(to: GKState())
          expect(creditsButton.parent).to(beNil())
        }
        
        it("should remove title from camera") {
          let title = SKSpriteNode()
          titleScreenState.title = title
          gameScene.camera?.addChild(title)
          titleScreenState.willExit(to: GKState())
          expect(title.parent).to(beNil())
        }
      }
    }
  }
}
