//
//  Matchstick.swift
//  SwiftGame
//
//  Created by 飘金 on 2017/5/23.
//  Copyright © 2017年 piaojin. All rights reserved.
//

import SpriteKit
class Matchstick : SKSpriteNode{
    //跑🏃
    let matchstickAtlas : SKTextureAtlas = SKTextureAtlas(named: "matchstick.atlas")
    var matchstickFrames : [SKTexture] = [SKTexture]()
    
    init(){
        let texture = self.matchstickAtlas.textureNamed("matchstick1")
        let size = texture.size()
        super.init(texture: texture, color: UIColor.white, size: size)
        
        /// MARK: 初始化所有的动作
        self.initAtlas(name: "matchstick", textureFrames: &self.matchstickFrames, atlas: self.matchstickAtlas)
        
        /// MARK: 设置物理属性
        //设置碰撞的有效大小范围
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        //设置碰撞标识
        self.physicsBody?.categoryBitMask = BitMaskType.matchstick
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
    
    //升龙拳
    func firePunch(){
        self.removeAllActions()
        self.run(SKAction.animate(with: self.matchstickFrames, timePerFrame: 0.04))
    }
}
