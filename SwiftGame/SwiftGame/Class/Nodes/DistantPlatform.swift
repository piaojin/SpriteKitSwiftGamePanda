//
//  DistantPlatform.swift
//  SwiftGame
//
//  Created by 飘金 on 2017/5/16.
//  Copyright © 2017年 piaojin. All rights reserved.
//

import SpriteKit
//远景
class DistantPlatform: SKNode {
    
    let texture = SKTexture(imageNamed: "background_f1")
    
    var width : CGFloat = 0.0
    var height : CGFloat = 0.0
    
    var platformArr = [SKSpriteNode]()
    
    override init() {
        let spriteNodeLeft = SKSpriteNode(texture: texture)
        spriteNodeLeft.position = CGPoint(x: 0, y: spriteNodeLeft.size.height)
        spriteNodeLeft.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        
        let spriteNodeRight = SKSpriteNode(texture: texture)
        spriteNodeRight.position = CGPoint(x: spriteNodeLeft.size.width, y: spriteNodeRight.size.height)
        spriteNodeRight.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        
        self.platformArr.append(spriteNodeLeft)
        self.platformArr.append(spriteNodeRight)
        
        self.width = spriteNodeLeft.size.width + spriteNodeRight.size.width
        self.height = spriteNodeLeft.size.height

        super.init()
        
        self.addChild(spriteNodeLeft)
        self.addChild(spriteNodeRight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(speed:CGFloat){
        for platform in self.platformArr{
            platform.position.x -= speed
        }
        
        //移除出了屏幕的土块
        guard let firstPlatform = platformArr.first else {
            return
        }
        
        //位于前面的草块移除屏幕时立马改变其坐标回到屏幕的最右边,重新进入屏幕移动
        if firstPlatform.position.x  <= -self.width / 2.0 {
            firstPlatform.position = CGPoint(x: self.width / 2.0, y: firstPlatform.position.y)
            (self.platformArr[0],self.platformArr[1]) = (self.platformArr[1],self.platformArr[0])
        }
    }
    
}
