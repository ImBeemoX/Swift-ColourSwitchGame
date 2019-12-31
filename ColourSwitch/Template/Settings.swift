//
//  Settings.swift
//  ColourSwitch
//
//  Created by 王一川 on 7/9/19.
//  Copyright © 2019 Wang Yichuan. All rights reserved.
//

import SpriteKit

enum PhysicsCategories{
    static let none: UInt32 = 0
    static let ballCategory:UInt32 = 0x1           // 01
    static let switchCategory: UInt32 = 0x1 << 1   // 10
}
