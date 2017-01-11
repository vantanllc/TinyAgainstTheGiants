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
