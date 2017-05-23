//
//  Bomb.swift
//  SwiftGame
//
//  Created by 飘金 on 2017/5/19.
//  Copyright © 2017年 piaojin. All rights reserved.
//

import SpriteKit
//炸弹💣
class Bombo : SKSpriteNode{
    //跑🏃
    let bomboAtlas : SKTextureAtlas = SKTextureAtlas(named: "bombo.atlas")
    var bomboFrames : [SKTexture] = [SKTexture]()
    let defaultSize = SKTexture(imageNamed: "Bomb").size()
    
    init(){
//        let texture = self.bomboAtlas.textureNamed("bombo_01")
        let texture = SKTexture(imageNamed: "Bomb")

        super.init(texture: texture, color: UIColor.white, size: self.defaultSize)
        
        /// MARK: 初始化所有的动作
        //爆炸
        self.initAtlas(name: "bombo_0", textureFrames: &self.bomboFrames, atlas: self.bomboAtlas)
        
        /// MARK: 设置物理属性
        //设置碰撞的有效大小范围
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        //设置碰撞标识
        self.physicsBody?.categoryBitMask = BitMaskType.bombo
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化动作
    func initAtlas(name:String, textureFrames:inout [SKTexture],atlas : SKTextureAtlas){
        //初始化所有的动作
        for i in 1...atlas.textureNames.count{
            let tempName = name + "\(i)"
            let texture = atlas.textureNamed(tempName)
            textureFrames.append(texture)
        }
    }
    
    //爆炸动作
    func bombo(){
        self.removeAllActions()
        self.size = CGSize(width: 300, height: 300)
        self.run(SKAction.animate(with: self.bomboFrames, timePerFrame: 0.05)) {[weak self]
            in
            if let weakSelf = self{
                weakSelf.size = weakSelf.defaultSize
            }
        }
    }
}
