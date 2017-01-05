//
//  TileDefinitionType.swift
//  TinyAgainstTheGiants
//
//  Created by Thinh Luong on 1/4/17.
//  Copyright © 2017 Vantan LLC. All rights reserved.
//

import Foundation

enum TileDefinitionType: String {
  case UpperLeftEdge, UpEdge, UpperRightEdge
  case LeftEdge, Center, RightEdge
  case LowerLeftEdge, DownEdge, LowerRightEdge
  case UpperLeftCorner, UpperRightCorner
  case LowerLeftCorner, LowerRightCorner
}
