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
    
    describe("addCamera") {
      it("should add camera node to scene") {
        let scene = SKScene()
        CameraBuilder.addCamera(camera, toScene: scene)
        expect(scene.camera).to(be(camera))
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
