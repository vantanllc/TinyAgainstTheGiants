//
//  TileMapPhysicsBuilderTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/3/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class TileMapPhysicsBuilderSpec: QuickSpec {
  override func spec() {
    describe("TileMapPhysicsBuilder") {
      var tileDefinition: SKTileDefinition!
      beforeEach {
        tileDefinition = SKTileDefinition(texture: SKTexture(), size: CGSize(width: 32, height: 32))
        tileDefinition.userData = ["tileDefinitionType": "Center"]
      }
      it("should have body") {
        let body = TileMapPhysicsBuilder.getPhysicsBodyFromTileDefinition(tileDefinition: tileDefinition, center: CGPoint.zero)
        expect(body).notTo(beNil())
      }
      
      describe("getScaleTransformForTileDefinitionType") {
        var tileDefinitionTypes: [TileDefinitionType]!
        var transforms: [CGAffineTransform]!
        let originalScaleTransform = CGAffineTransform(scaleX: 1, y: 1)
        let halfYScaleTransform = CGAffineTransform(scaleX: 1, y: 0.5)
        let halfXScaleTransform = CGAffineTransform(scaleX: 0.5, y: 1)
        let halfYHalfXScaleTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        afterEach {
          tileDefinitionTypes = nil
          transforms = nil
        }
        
        it("should return expected scale transform for .Center") {
          tileDefinitionTypes = [.Center]
          transforms = tileDefinitionTypes.flatMap { type in
            return TileMapPhysicsBuilder.getScaleTransformForTileDefinitionType(type)
          }
          expect(transforms).to(allPass(equal(originalScaleTransform)))
        }
        
        it("should return expected scale transform for Up/Down Edge") {
          tileDefinitionTypes = [.UpEdge, .DownEdge]
          transforms = tileDefinitionTypes.flatMap { type in
            return TileMapPhysicsBuilder.getScaleTransformForTileDefinitionType(type)
          }
          expect(transforms).to(allPass(equal(halfYScaleTransform)))
        }
        
        it("should return expected scale transform for Left/Right Edge") {
          tileDefinitionTypes = [.LeftEdge, .RightEdge]
          transforms = tileDefinitionTypes.flatMap { type in
            return TileMapPhysicsBuilder.getScaleTransformForTileDefinitionType(type)
          }
          expect(transforms).to(allPass(equal(halfXScaleTransform)))
        }
        
        it("should return expected scale transform for Upper/Lower Left/Right Edge") {
          tileDefinitionTypes = [.UpperLeftEdge, .UpperRightEdge, .LowerLeftEdge, .LowerRightEdge]
          transforms = tileDefinitionTypes.flatMap { type in
            return TileMapPhysicsBuilder.getScaleTransformForTileDefinitionType(type)
          }
          expect(transforms).to(allPass(equal(halfYHalfXScaleTransform)))
        }
        
        it("should return expected scale transform for a Upper/Lower Left/Right Corner") {
          tileDefinitionTypes = [.UpperLeftCorner, .UpperRightCorner, .LowerLeftCorner, .LowerRightCorner]
          transforms = tileDefinitionTypes.flatMap { type in
            return TileMapPhysicsBuilder.getScaleTransformForTileDefinitionType(type)
          }
          expect(transforms).to(allPass(equal(halfYHalfXScaleTransform)))
        }
      }
      
      describe("getTranslationTransformForTileDefinitionTypeCorner") {
        var tileDefinitionType: TileDefinitionType!
        var transforms: (firstTransform: CGAffineTransform, secondTransform: CGAffineTransform)!
        let tileSize = CGSize(width: 100, height: 100)
        let noTranslationTransform = CGAffineTransform(translationX: 0, y: 0)
        let oneQuarterUpRightTranslationTransform = CGAffineTransform(translationX: 0.25 * tileSize.width, y: 0.25 * tileSize.height)
        let oneQuarterDownRightTranslationTransform = CGAffineTransform(translationX: 0.25 * tileSize.width, y: -0.25 * tileSize.height)
        let oneQuarterUpLeftTranslationTransform = CGAffineTransform(translationX: -0.25 * tileSize.width, y: 0.25 * tileSize.height)
        let oneQuarterDownLeftTranslationTransform = CGAffineTransform(translationX: -0.25 * tileSize.width, y: -0.25 * tileSize.height)
        
        afterEach {
          tileDefinitionType = nil
          transforms = nil
        }
        
        it("should return expected translation transforms for non-Corner type") {
          let tileDefinitionTypes: [TileDefinitionType] = [
            .UpperLeftEdge, .UpEdge, .UpperLeftEdge,
            .LeftEdge, .Center, .RightEdge,
            .LowerLeftEdge, .DownEdge, .LowerRightEdge
          ]
          
          let transformTuples: [(firstTransform: CGAffineTransform, secondTransform: CGAffineTransform)] = tileDefinitionTypes.flatMap { type in
            return TileMapPhysicsBuilder.getTranslationTransformsForTileDefinitionTypeCorner(type, withTileSize: tileSize)
          }
          
          for transform in transformTuples {
            expect(transform.firstTransform).to(equal(noTranslationTransform))
            expect(transform.secondTransform).to(equal(noTranslationTransform))
          }
        }
        
        it("should return expected translation transforms for .UpperLeftCorner") {
          tileDefinitionType = .UpperLeftCorner
          transforms = TileMapPhysicsBuilder.getTranslationTransformsForTileDefinitionTypeCorner(tileDefinitionType, withTileSize: tileSize)
          expect(transforms.firstTransform).to(equal(oneQuarterUpRightTranslationTransform))
          expect(transforms.secondTransform).to(equal(oneQuarterDownLeftTranslationTransform))
        }
        
        it("should return expected translation transforms for .UpperRightCorner") {
          tileDefinitionType = .UpperRightCorner
          transforms = TileMapPhysicsBuilder.getTranslationTransformsForTileDefinitionTypeCorner(tileDefinitionType, withTileSize: tileSize)
          expect(transforms.firstTransform).to(equal(oneQuarterUpLeftTranslationTransform))
          expect(transforms.secondTransform).to(equal(oneQuarterDownRightTranslationTransform))
        }
        
        it("should return expected translation transforms for .LowerLeftCorner") {
          tileDefinitionType = .LowerLeftCorner
          transforms = TileMapPhysicsBuilder.getTranslationTransformsForTileDefinitionTypeCorner(tileDefinitionType, withTileSize: tileSize)
          expect(transforms.firstTransform).to(equal(oneQuarterUpLeftTranslationTransform))
          expect(transforms.secondTransform).to(equal(oneQuarterDownRightTranslationTransform))
        }
        
        it("should return expected translation transforms for .LowerRightCorner") {
          tileDefinitionType = .LowerRightCorner
          transforms = TileMapPhysicsBuilder.getTranslationTransformsForTileDefinitionTypeCorner(tileDefinitionType, withTileSize: tileSize)
          expect(transforms.firstTransform).to(equal(oneQuarterUpRightTranslationTransform))
          expect(transforms.secondTransform).to(equal(oneQuarterDownLeftTranslationTransform))
        }
      }
      
      describe("getTranslationTransformForTileDefinitionType") {
        var tileDefinitionType: TileDefinitionType!
        var transform: CGAffineTransform!
        let tileSize = CGSize(width: 100, height: 100)
        let noTranslationTransform = CGAffineTransform(translationX: 0, y: 0)
        let oneQuarterDownTranslationTransform = CGAffineTransform(translationX: 0, y: -0.25 * tileSize.height)
        let oneQuarterUpTranslationTransform = CGAffineTransform(translationX: 0, y: 0.25 * tileSize.height)
        let oneQuarterLeftTranslationTransform = CGAffineTransform(translationX: -0.25 * tileSize.width, y: 0)
        let oneQuarterRightTranslationTransform = CGAffineTransform(translationX: 0.25 * tileSize.width, y: 0)
        let oneQuarterUpRightTranslationTransform = CGAffineTransform(translationX: 0.25 * tileSize.width, y: 0.25 * tileSize.height)
        let oneQuarterDownRightTranslationTransform = CGAffineTransform(translationX: 0.25 * tileSize.width, y: -0.25 * tileSize.height)
        let oneQuarterUpLeftTranslationTransform = CGAffineTransform(translationX: -0.25 * tileSize.width, y: 0.25 * tileSize.height)
        let oneQuarterDownLeftTranslationTransform = CGAffineTransform(translationX: -0.25 * tileSize.width, y: -0.25 * tileSize.height)

        afterEach {
          tileDefinitionType = nil
        }
        
        it("should return expected translation transform for .Center") {
          tileDefinitionType = .Center
          transform = TileMapPhysicsBuilder.getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
          expect(transform).to(equal(noTranslationTransform))
        }
        
        it("should return expected translation transform for .UpEdge") {
          tileDefinitionType = .UpEdge
          transform = TileMapPhysicsBuilder.getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
          expect(transform).to(equal(oneQuarterDownTranslationTransform))
        }
        
        it("should return expected translation transform for .DownEdge") {
          tileDefinitionType = .DownEdge
          transform = TileMapPhysicsBuilder.getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
          expect(transform).to(equal(oneQuarterUpTranslationTransform))
        }
        
        it("should return expected translation transform for .LeftEdge") {
          tileDefinitionType = .LeftEdge
          transform = TileMapPhysicsBuilder.getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
          expect(transform).to(equal(oneQuarterRightTranslationTransform))
        }
        
        it("should return expected translation transform for .RightEdge") {
          tileDefinitionType = .RightEdge
          transform = TileMapPhysicsBuilder.getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
          expect(transform).to(equal(oneQuarterLeftTranslationTransform))
        }
        
        it("should return expected translation transform for .UpperLeftEdge") {
          tileDefinitionType = .UpperLeftEdge
          transform = TileMapPhysicsBuilder.getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
          expect(transform).to(equal(oneQuarterDownRightTranslationTransform))
        }
        
        it("should return expected translation transform for .UpperRightEdge") {
          tileDefinitionType = .UpperRightEdge
          transform = TileMapPhysicsBuilder.getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
          expect(transform).to(equal(oneQuarterDownLeftTranslationTransform))
        }
        
        it("should return expected translation transform for .LowerLeftEdge") {
          tileDefinitionType = .LowerLeftEdge
          transform = TileMapPhysicsBuilder.getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
          expect(transform).to(equal(oneQuarterUpRightTranslationTransform))
        }
        
        it("should return expected translation transform for .LowerRightEdge") {
          tileDefinitionType = .LowerRightEdge
          transform = TileMapPhysicsBuilder.getTranslationTransformForTileDefinitionType(tileDefinitionType, withTileSize: tileSize)
          expect(transform).to(equal(oneQuarterUpLeftTranslationTransform))
        }
      }
    }
  }
}


