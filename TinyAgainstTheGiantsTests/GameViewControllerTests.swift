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
      var gameScene: GameScene!
      
      beforeEach {
        gameVC = GameViewController()
        gameVC.view = SKView()
      }
      
      it("should present GameScene in view") {
        gameVC.viewDidLoad()
        if let view = gameVC.view as? SKView {
          expect(view.scene).toNot(beNil())
        }
      }
      
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
      
      describe("createGameScene") {
        it("should return GameScene with expected size") {
          gameScene = gameVC.createGameScene(size: expectedSize)
          expect(gameScene.size).to(equal(expectedSize))
        }
        
        it("should default to .resizeFill scaleMode") {
          gameScene = gameVC.createGameScene(size: expectedSize)
          expect(gameScene.scaleMode).to(equal(SKSceneScaleMode.resizeFill))
        }
        
        it("should return GameScene with expected scaleMode") {
          let expectedScaleMode: SKSceneScaleMode = .aspectFit
          gameScene = gameVC.createGameScene(size: expectedSize, scaleMode: expectedScaleMode)
          expect(gameScene.scaleMode).to(equal(expectedScaleMode))
        }
      }
      
      describe("presentGameSceneInDevMode") {
        var skView: SKView!
        
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
