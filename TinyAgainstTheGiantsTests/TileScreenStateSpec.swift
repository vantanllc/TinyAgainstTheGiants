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
      
      context("createLabel") {
        var title: SKLabelNode!
        let expectedText = "I am expected"
        
        beforeEach {
          title = titleScreenState.createLabel(withText: expectedText)
        }
        
        it("should have zPosition set to label") {
          expect(title.zPosition).to(equal(NodeLayerPosition.label))
        }
        
        it("should have title label identifier") {
          expect(title.name).to(equal(LabelIdentifier.title.rawValue))
        }
        
        it("should set text") {
          expect(title.text).to(equal(expectedText))
        }
        
        it("should be top aligned") {
          expect(title.verticalAlignmentMode).to(equal(SKLabelVerticalAlignmentMode.top))
        }
        
        it("should be center aligned") {
          expect(title.horizontalAlignmentMode).to(equal(SKLabelHorizontalAlignmentMode.center))
        }
      }
      
      context("didEnter") {
        beforeEach {
          gameScene.addBackgroundTileMap()
          titleScreenState.didEnter(from: nil)
        }
        
        it("should add start button to camera") {
          expect(gameScene.camera?.childNode(withName: ButtonIdentifier.start.rawValue)).toNot(beNil())
        }
        
        it("should add title to camera") {
          expect(titleScreenState.title.parent).to(be(gameScene.camera))
        }
      }
      
      context("willExit") {
        it("should remove start button from camera") {
          let startButton = ButtonBuilder.getStartButton()
          gameScene.camera?.addChild(startButton)
          titleScreenState.willExit(to: GKState())
          expect(gameScene.camera?.childNode(withName: ButtonIdentifier.start.rawValue)).to(beNil())
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
