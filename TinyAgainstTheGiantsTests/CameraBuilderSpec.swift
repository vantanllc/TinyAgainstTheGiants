//
//  CameraBuilderSpec.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/1/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class CameraBuilderSpec: QuickSpec {
  override func spec() {
    var camera: SKCameraNode!
    
    beforeEach {
      camera = SKCameraNode()
    }
    
    
    describe("constraintCamera(_:toSpriteNode)") {
      it("should update camera constraint") {
        CameraBuilder.constraintCamera(camera, toSpriteNode: SKSpriteNode())
        expect(camera.constraints).to(haveCount(1))
      }
    }
    
    describe("constraintCamera(_:ToTileMapEdges)") {
      it("should update camera constraint") {
        let tileMap = SKTileMapNode()
        let scene = SKScene()
        
        CameraBuilder.constraintCamera(camera, toTileMapEdges: tileMap, inScene: scene)
        expect(camera.constraints).to(haveCount(1))
      }
    }
    
    describe("createCameraConstraintToCenterOnSpriteNode") {
      it("should return expected constraint") {
        let node = SKSpriteNode()
        let constraint = CameraBuilder.createCameraConstraintToCenterOnSpriteNode(node)
        expect(constraint).toNot(beNil())
      }
    }
    
    describe("addCamera") {
      var scene: SKScene!
      beforeEach {
        scene = SKScene()
      }
      it("should add camera node to scene.camera") {
        CameraBuilder.addCamera(camera, toScene: scene)
        expect(scene.camera).to(be(camera))
      }
      
      it("should add camera node to scene as child") {
        CameraBuilder.addCamera(camera, toScene: scene)
        expect(scene.children).to(contain(camera))
      }
    }
    
    describe("addConstraints") {
      context("when there are no current constraints") {
        it("should add constraints to camera") {
          let expectedConstraints = [SKConstraint(), SKConstraint()]
          CameraBuilder.addContraints(expectedConstraints, toCamera: camera)
          expect(camera.constraints).to(be(expectedConstraints))
        }
      }
      
      context("when there are current constraints") {
        it("should append constraints to camera") {
          let expectedCamera = SKCameraNode()
          let currentConstraints = [SKConstraint()]
          expectedCamera.constraints = currentConstraints
          let newConstraints = [SKConstraint(), SKConstraint()]
          
          CameraBuilder.addContraints(newConstraints, toCamera: expectedCamera)
          
          expect(expectedCamera.constraints).to(equal(currentConstraints + newConstraints))
        }
      }
    }
  }
}
