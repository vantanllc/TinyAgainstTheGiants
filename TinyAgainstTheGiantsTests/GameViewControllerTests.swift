//
//  GameViewControllerTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import Quick
import Nimble
import SpriteKit

@testable import TinyAgainstTheGiants

class GameViewControllerSpec: QuickSpec {
  override func spec() {
    var gameVC: GameViewController!
    let expectedSize = CGSize(width: 1366, height: 1024)

    describe("GameViewController") {
      beforeEach {
        gameVC = GameViewController()
        gameVC.view = SKView()
      }
      
      describe("loading view") {
        it("should present GameScene in view") {
          gameVC.viewDidLoad()
          if let view = gameVC.view as? SKView {
            expect(view.scene).toNot(beNil())
          } else {
            fail("Unexpectedly got nil.")
          }
        }
        
        describe("viewDidLayoutSubviews") {
          it("should sync gameScene.size with view.size") {
            let oldSize = CGSize(width: 100, height: 100)
            let newSize = CGSize(width: 200, height: 200)
            gameVC.gameScene = GameScene(size: oldSize)
            gameVC.view.bounds.size = newSize
            
            gameVC.viewDidLayoutSubviews()
            
            expect(gameVC.gameScene.size).to(equal(newSize))
          }
        }
      }
      
      describe("configuration") {
        it("should allow autorotate") {
          expect(gameVC.shouldAutorotate).to(beTrue())
        }
        
        it("should only support .allButUpsideDown orientation") {
          let allButUpsideDown = UIInterfaceOrientationMask.allButUpsideDown
          expect(gameVC.supportedInterfaceOrientations).to(equal(allButUpsideDown))
        }
        
        it("should hide status bar") {
          expect(gameVC.prefersStatusBarHidden).to(beTrue())
        }
      }
      
      describe("createGameScene") {
        it("should return GameScene with expected size") {
          let gameScene = gameVC.createGameScene(size: expectedSize)
          expect(gameScene.size).to(equal(expectedSize))
        }
        
        it("should default to .resizeFill scaleMode") {
          let gameScene = gameVC.createGameScene(size: expectedSize)
          expect(gameScene.scaleMode).to(equal(SKSceneScaleMode.resizeFill))
        }
        
        it("should return GameScene with expected scaleMode") {
          let expectedScaleMode: SKSceneScaleMode = .aspectFit
          let gameScene = gameVC.createGameScene(size: expectedSize, scaleMode: expectedScaleMode)
          expect(gameScene.scaleMode).to(equal(expectedScaleMode))
        }
      }
      
      describe("presentGameSceneInDevMode") {
        var skView: SKView!
        var gameScene: GameScene!
        
        beforeEach {
          gameScene = gameVC.createGameScene(size: expectedSize)
          skView = SKView()
        }
        
        it("should turn on SKView visual debug flags") {
          gameVC.presentGameSceneInDevMode(gameScene: gameScene, intoSKView: skView)
          let debugFlags = [skView.showsFPS, skView.showsNodeCount, skView.showsPhysics]
          expect(debugFlags).to(allPass(beTrue()))
        }
        
        it("should present GameScene in SkView") {
          gameVC.presentGameSceneInDevMode(gameScene: gameScene, intoSKView: skView)
          expect(skView.scene).to(equal(gameScene))
        }
      }
    }
  }
}
