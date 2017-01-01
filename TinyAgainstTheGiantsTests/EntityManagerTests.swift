//
//  EntityManagerTests.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 12/31/16.
//  Copyright © 2016 Vantan LLC. All rights reserved.
//

import GameplayKit

import Quick
import Nimble
@testable import TinyAgainstTheGiants

class EntityManagerSpec: QuickSpec {
  override func spec() {
    var entityManager: EntityManager!
    
    describe("EntityManager") {
      var gameScene: GameScene!
      
      beforeEach {
        gameScene = GameScene()
        entityManager = EntityManager(scene: gameScene)
      }
      
      it("should have reference to GameScene") {
        expect(entityManager.scene).to(be(gameScene))
      }
      
      describe("basic functions") {
        var expectedEntity: GKEntity!
        
        beforeEach {
          expectedEntity = GKEntity()
          entityManager.entities.removeAll()
          entityManager.entitiesToRemove.removeAll()
        }
        
        describe("add") {
          it("should add entity to entities property") {
            entityManager.add(entity: expectedEntity)
            expect(entityManager.entities).to(contain(expectedEntity))
          }
          
          context("input entity has RenderComponent") {
            it("should add RenderComponent.node to scene") {
              let renderComponent = RenderComponent()
              expectedEntity.addComponent(renderComponent)
              entityManager.add(entity: expectedEntity)
              
              expect(entityManager.scene.children).to(contain(renderComponent.node))
            }
          }
        }
        
        describe("remove") {
          it("should remove entity from entities property") {
            entityManager.entities.insert(expectedEntity)
            entityManager.remove(entity: expectedEntity)
            expect(entityManager.entities).toNot((contain(expectedEntity)))
          }
          
          it("should add entity to entitiesToRemove property") {
            entityManager.entities.insert(expectedEntity)
            entityManager.remove(entity: expectedEntity)
            expect(entityManager.entitiesToRemove).to((contain(expectedEntity)))
          }
          
          context("input entity has RenderComponent") {
            it("should remove RenderComponent.node from scene") {
              let renderComponent = RenderComponent()
              expectedEntity.addComponent(renderComponent)
              entityManager.scene.addChild(renderComponent.node)
              
              entityManager.remove(entity: expectedEntity)
              
              expect(entityManager.scene.children).toNot(contain(renderComponent.node))
            }
          }
        }
      }
    }
  }
}
