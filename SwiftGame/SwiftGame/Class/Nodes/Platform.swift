//
//  Platform.swift
//  SwiftGame
//
//  Created by 飘金 on 2017/5/12.
//  Copyright © 2017年 piaojin. All rights reserved.
//

import SpriteKit

class Platform: SKNode {
    
    var width : CGFloat = 0.0
    var heigth  : CGFloat = 10.0
    
    var matchstick : Matchstick = Matchstick()
   
    func onCreate(arrSprite : [SKSpriteNode]){
        for platform in arrSprite{
            platform.position.x = self.width
            self.addChild(platform)
            self.width += platform.size.width
            self.heigth = platform.size.height
        }
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.width, height: self.heigth), center: CGPoint(x:self.width/2, y:0))
        self.physicsBody?.categoryBitMask = BitMaskType.platform
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        
    }
}
