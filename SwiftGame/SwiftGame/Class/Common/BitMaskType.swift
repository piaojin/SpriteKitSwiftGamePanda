//
//  BitMaskType.swift
//  SwiftGame
//
//  Created by 飘金 on 2017/5/16.
//  Copyright © 2017年 piaojin. All rights reserved.
//

import Foundation
struct BitMaskType {
    static var panda : UInt32 {
        return 1<<0
    }
    
    static var apple : UInt32 {
        return 1<<1
    }
    
    static var platform : UInt32 {
        return 1<<2
    }
    
    static var scene : UInt32 {
        return 1<<3
    }
}
