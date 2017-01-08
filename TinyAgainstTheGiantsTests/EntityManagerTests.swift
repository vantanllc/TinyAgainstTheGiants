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
    var gameScene: GameScene!

    describe("EntityManager") {
      beforeEach {
        gameScene = GameScene()
        entityManager = EntityManager(scene: gameScene)
      }
      
      it("should have reference to GameScene") {
        expect(entityManager.scene).to(be(gameScene))
      }
      
      describe("Behavior functions") {
        describe ("getEntitiesForTeam") {
          it("should return expected entities of specified team") {
            let entityFromTeamOne = PlayerEntity(node: SKSpriteNode())
            let entityFromTeamTwo = EnemyEntity(node: SKSpriteNode())
            entityManager.entities.insert(entityFromTeamOne)
            entityManager.entities.insert(entityFromTeamTwo)
            
            let entities = entityManager.getEntitiesForTeam(.One)
            expect(entities).to(equal([entityFromTeamOne]))
          }
        }
        describe("getMoveComponentsForTeam") {
          it("should return expected MoveComponents for entities of specified team") {
            let entity = PlayerEntity(node: SKSpriteNode())
            guard let expectedMoveComponent = entity.component(ofType: MoveComponent.self) else {
              fail(unexpectedlyFoundNil)
              return
            }
            
            entityManager.entities.insert(entity)
            let moveComponents = entityManager.getMoveComponentsForTeam(.One)
            
            expect(moveComponents).to(contain(expectedMoveComponent))
          }
        }
      }
      
      describe("Enemy functions") {
        var expectedNode: SKSpriteNode!
        var expectedEnemyEntity: EnemyEntity!
        var expectedEnemyEntities: [EnemyEntity]!
    
        beforeEach {
          expectedNode = SKSpriteNode()
          expectedEnemyEntity = EnemyEntity(node: expectedNode)
          expectedEnemyEntities = []
          expectedEnemyEntities.append(expectedEnemyEntity)
          entityManager.entities.insert(expectedEnemyEntity)
        }
        
        describe("getEnemyEntities") {
          it("should return enemy entities") {
            let entities = entityManager.getEnemyEntities()
            expect(entities).to(equal(expectedEnemyEntities))
          }
        }
      }
      
      describe("Player function") {
        var expectedNode: SKSpriteNode!
        var expectedPlayerEntity: PlayerEntity!
        
        beforeEach {
          expectedNode = SKSpriteNode()
          expectedPlayerEntity = PlayerEntity(node: expectedNode)
          entityManager.entities.insert(expectedPlayerEntity)
        }
        describe("getPlayerEntity") {
          it("should return player's entity") {
            let entity = entityManager.getPlayerEntity()
            expect(entity).to(be(expectedPlayerEntity))
          }
        }
        
        describe("getPlayerSpriteNode") {
          it("should return player's skspritenode") {
            let node = entityManager.getPlayerSpriteNode()
            expect(node).to(be(expectedNode))
          }
        }
        
        describe("getPlayerRenderNode") {
          it("should return player's sknode") {
            let node = entityManager.getPlayerRenderNode()
            expect(node).toNot(beNil())
          }
        }
      }
      
      describe("collection functions") {
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
              
              expect(entityManager.scene.worldNode.children).to(contain(renderComponent.node))
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
