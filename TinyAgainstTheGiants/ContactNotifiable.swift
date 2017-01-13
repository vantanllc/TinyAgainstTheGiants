//
//  ContactNotifiable.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/10/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import GameplayKit

@objc protocol ContactNotifiable: class {
  @objc optional func contactWithEntityDidBegin(_ entity: GKEntity)
  @objc optional func contactWithEntityDidEnd(_ entity: GKEntity)
}

func handleContact(contact: SKPhysicsContact, contactCallBack: (ContactNotifiable, GKEntity) -> Void) {
  let colliderTypeA = ColliderType(rawValue: contact.bodyA.categoryBitMask)
  let colliderTypeB = ColliderType(rawValue: contact.bodyB.categoryBitMask)
  
  let aWantsCallBack = colliderTypeA.notifyOnContactWith(colliderTypeB)
  let bWantsCallBack = colliderTypeB.notifyOnContactWith(colliderTypeA)
  
  let entityA = contact.bodyA.node?.entity
  let entityB = contact.bodyB.node?.entity
  
  if let notifiableEntity = entityA as? ContactNotifiable, let otherEntity = entityB, aWantsCallBack {
    contactCallBack(notifiableEntity, otherEntity)
  }
  
  if let notifiableEntity = entityB as? ContactNotifiable, let otherEntity = entityA, bWantsCallBack {
    contactCallBack(notifiableEntity, otherEntity)
  }
}
