//
//  PlatformFactory.swift
//  SwiftGame
//
//  Created by 飘金 on 2017/5/12.
//  Copyright © 2017年 piaojin. All rights reserved.
//

import SpriteKit

protocol UpdatePlatform :NSObjectProtocol{
    func updateDis(lastDis:CGFloat)
}

class PlatformFactory: SKNode {
    
    let textureLeft = SKTexture(imageNamed: "platform_l")
    let textureMid = SKTexture(imageNamed: "platform_m")
    let textureRight = SKTexture(imageNamed: "platform_r")
    let textureApple = SKTexture(imageNamed: "apple")
    
    weak var delegate : UpdatePlatform?
    
    var sceneWidth : CGFloat = 0.0
    
    var scenHeight : CGFloat = 0.0
    
    var platforms = [Platform]()
    
    var midCount : UInt32 = 4
    
    //间距
    var M : UInt32 = 50
    
    func createPlatformRandom(){
        //随机中间土块数量
        let midNum : UInt32 = arc4random() % self.midCount + 1
        
        //随机间距
        let m : UInt32 = arc4random() % 4 + 1
        
        //随机生成苹果或炸弹或火柴人
        let npcCode : UInt32 = arc4random() % 4 + 1
        
        let x : CGFloat = self.sceneWidth + CGFloat(m * self.M)
        let y : CGFloat = CGFloat(arc4random() % 3)
        self.createPlatform(midNum: Int(midNum), x: x, y: y,npcCode : npcCode,m : Int(m))
    }
    
    func createPlatform(midNum:Int,x:CGFloat,y:CGFloat,npcCode : UInt32,m : Int = 5){
        let platform = Platform()
        
        let platform_left = SKSpriteNode(texture: self.textureLeft)
        platform_left.anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let platform_right = SKSpriteNode(texture: self.textureRight)
        platform_right.anchorPoint = CGPoint(x: 0, y: 1.0)
        
        var arrPlatforms : [SKSpriteNode] = [SKSpriteNode]()
        //加入平台左边部分
        arrPlatforms.append(platform_left)
        
        //循环加入中间部分
        for _ in 1...midNum{
            let platform_mid = SKSpriteNode(texture: self.textureMid)
            platform_mid.anchorPoint = CGPoint(x: 0, y: 1.0)
            arrPlatforms.append(platform_mid)
        }
        
        //加入平台右边部分
        arrPlatforms.append(platform_right)
        
        platform.onCreate(arrSprite: arrPlatforms)
        
        if npcCode == 1{
            //加入炸弹💣
            let bombo = Bombo()
            bombo.position = CGPoint(x:platform.width / 2.0,y:CGFloat((m + 1) * 40))
            platform.addChild(bombo)
        }else if npcCode == 2{
            //加入火柴人
            let matchstick = Matchstick()
            matchstick.position = CGPoint(x:platform.width / 2.0,y:matchstick.size.height / 2.0)
            platform.addChild(matchstick)
        }else{
            //加入苹果
            let appleSprite = SKSpriteNode(texture:self.textureApple)
            appleSprite.position = CGPoint(x:platform.width / 2.0,y:CGFloat((m + 1) * 50))
            appleSprite.physicsBody = SKPhysicsBody(rectangleOf: appleSprite.size)
            appleSprite.physicsBody?.categoryBitMask = BitMaskType.apple
            appleSprite.physicsBody?.isDynamic = false
            platform.addChild(appleSprite)
        }
        
        let tempY = (y - 1) * platform.heigth
        
        platform.position = CGPoint(x: x, y: tempY)
        
        self.addChild(platform)
        
        self.delegate?.updateDis(lastDis: platform.width + x)
        
        platforms.append(platform)
    }
    
    func move(speed:CGFloat){
        for platform in self.platforms{
            platform.position.x -= speed
        }
        
        //移除出了屏幕的土块
        guard let firstPlatform = platforms.first else {
            return
        }
        
        //土块移除屏幕是销毁土块
        if (firstPlatform.position.x ) < -(firstPlatform.width + PJGameHeight / 2.0) || firstPlatform.position.y < -PJGameHeight / 2.0{
            firstPlatform.removeFromParent()
            self.platforms.removeFirst()
        }
    }
    
    func removePlatforms(){
        for platform in self.platforms{
            platform.removeFromParent()
        }
    }
    
}
