//
//  Panda.swift
//  SwiftGame
//
//  Created by 飘金 on 2017/5/12.
//  Copyright © 2017年 piaojin. All rights reserved.
//

import SpriteKit

enum ActionState:Int {
    case run = 1,/*跑*/jump_stair/*一级跳*/,jump_second,/*二级跳*/roll//滚
}

class Panda: SKSpriteNode {

    //跑🏃
    let runAtlas : SKTextureAtlas = SKTextureAtlas(named: "run.atlas")
    var runFrames : [SKTexture] = [SKTexture]()
    
    //跳
    let jumpAtlas : SKTextureAtlas = SKTextureAtlas(named: "jump.atlas")
    var jumpFrames : [SKTexture] = [SKTexture]()
    
    //滚
    let rollAtlas : SKTextureAtlas = SKTextureAtlas(named: "roll.atlas")
    var rollFrames : [SKTexture] = [SKTexture]()
    
    
    var actionState = ActionState.run
    
    
    init() {
        let texture = self.runAtlas.textureNamed("panda_run_01")
        let size = texture.size()
        super.init(texture: texture, color: UIColor.white, size: size)
        
        /// MARK: 初始化所有的动作
        //跑
        self.initAtlas(name: "panda_run_0", textureFrames: &self.runFrames, atlas: self.runAtlas)
        //跳
        self.initAtlas(name: "panda_jump_0", textureFrames: &self.jumpFrames, atlas: self.jumpAtlas)
        //滚
        self.initAtlas(name: "panda_roll_0", textureFrames: &self.rollFrames, atlas: self.rollAtlas)
        
        /// MARK: 设置物理属性
        //设置碰撞的有效大小范围
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        //设置碰撞标识
        self.physicsBody?.categoryBitMask = BitMaskType.panda
        //碰撞后有反作用力,即有受重力作用
        self.physicsBody?.isDynamic = true
        //碰撞后不旋转
        self.physicsBody?.allowsRotation = false
        //设置摩擦力
        self.physicsBody?.restitution = 0.1
        //设置可以跟谁碰撞
        self.physicsBody?.contactTestBitMask = BitMaskType.scene | BitMaskType.platform | BitMaskType.apple
        //定义了哪种物体会碰撞到自己
        self.physicsBody?.collisionBitMask = BitMaskType.scene | BitMaskType.platform
        
        
        //默认跑
        self.run()
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
    
    func run(){
        self.removeAllActions()
        self.actionState = .run
        self.run(SKAction.repeatForever(SKAction.animate(with: self.runFrames, timePerFrame: 0.05)))
    }
    
    func jump(){
        self.removeAllActions()
        if self.actionState != .jump_second && self.actionState != .roll{
            self.run(SKAction.animate(with: self.jumpFrames, timePerFrame: 0.05))
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 450)
            if self.actionState == .jump_stair{
                self.actionState = .jump_second
                self.roll()
            }else{
                self.actionState = .jump_stair
            }
        }
    }
    
    func roll(){
        self.removeAllActions()
        self.actionState = .roll
        self.run(SKAction.animate(with: self.rollFrames, timePerFrame: 0.05),completion: {
//            self.run()
        })
    }
    
}
