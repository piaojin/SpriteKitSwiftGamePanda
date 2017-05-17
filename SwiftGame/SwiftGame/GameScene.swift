//
//  GameScene.swift
//  SwiftGame
//
//  Created by 飘金 on 2017/5/11.
//  Copyright © 2017年 piaojin. All rights reserved.
//

import SpriteKit
import GameplayKit
enum GameState {
    case gameOver,gameRun
}

class GameScene: SKScene ,UpdatePlatform,SKPhysicsContactDelegate{
    
    lazy var panda = Panda()
    
    lazy var platformFactory = PlatformFactory()
    
    lazy var distantPlatform = DistantPlatform()
    
    lazy var nearPlatform = NearPlatform()
    
    var isFirstStart : Bool = false
    
    var gameState = GameState.gameRun
    
    lazy var gameOverLabel : SKLabelNode = {
        let label = SKLabelNode(text: "飘金😏")
        label.fontColor = SKColor.orange
        label.fontSize = 40.0
        label.position = CGPoint(x: 0, y: 0)
        label.zPosition = 4.0
        return label
    }()
    
    lazy var scoreLabel : SKLabelNode = {
        let label = SKLabelNode(text: "🐷🐷🐷🐷🐷🐷:0")
        label.fontColor = SKColor.red
        label.fontSize = 30.0
        label.position = CGPoint(x: -PJGameWidth + label.frame.size.width, y: 150)
        label.zPosition = 5.0
        
        return label
    }()
    
    var score : CGFloat = 0.0
    
    var distance : CGFloat = 0.0
    
    var moveSpeed : CGFloat = 15.0
    
    var lastDis : CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        let skyColor = SKColor(red: 113 / 255, green: 197 / 255, blue: 207 / 255, alpha: 1)
        self.backgroundColor = skyColor
        self.physicsWorld.contactDelegate = self
        //设置重力
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        //设置物理碰撞检测范围
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        //设置碰撞检测标识
        self.physicsBody?.categoryBitMask = BitMaskType.scene
        self.physicsBody?.isDynamic = false
        
        
        //添加远景
        self.distantPlatform.position = CGPoint(x: -PJGameWidth, y: -self.distantPlatform.height)
        self.distantPlatform.zPosition = 0.0
        self.addChild(self.distantPlatform)
        
        //添加近景
        self.nearPlatform.position = CGPoint(x: -PJGameWidth, y: -self.nearPlatform.height)
        self.nearPlatform.zPosition = 1.0
        self.addChild(self.nearPlatform)
        
        //添加草块
        self.platformFactory.sceneWidth = self.frame.size.height
        self.platformFactory.scenHeight = self.frame.size.width
        self.platformFactory.delegate = self
        self.platformFactory.createPlatform(midNum: 3, x: -PJGameWidth, y: 0)
        self.platformFactory.zPosition = 2.0
        self.addChild(self.platformFactory)
        
        //添加熊猫🐼
        self.panda.position = CGPoint(x: -PJGameWidth + 10, y: self.platformFactory.position.y + self.panda.size.height)
        self.panda.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        self.panda.zPosition = 3.0
        self.addChild(self.panda)
        
        self.gameOverLabel.isHidden = true
        self.addChild(self.gameOverLabel)
        
        //添加分数
        self.addChild(self.scoreLabel)
    }
    
    func reSetGame(){
        
        self.moveSpeed = 15.0
        self.score = 0.0
        self.distance = 0.0
        self.gameState = .gameRun
        self.lastDis = 0.0
        
        self.gameOverLabel.isHidden = true
        
        self.platformFactory.removePlatforms()
        self.platformFactory.createPlatform(midNum: 3, x: PJGameWidth, y: 0)
        
        self.panda.position = CGPoint(x: -PJGameWidth + 10, y: PJGameHeight / 2.0 + self.panda.size.height)
        self.panda.physicsBody?.velocity = CGVector(dx: 0, dy: 50)
        
        self.panda.physicsBody?.allowsRotation = false
        
        self.addChild(self.panda)
    }
    
    func gameOver(){
        self.gameState = .gameOver
        self.gameOverLabel.isHidden = false
        self.panda.removeFromParent()
        debugPrint("🐼掉到场景外!")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //屏幕点击事件
        if self.gameState == .gameOver{
            //重新开始游戏
            self.reSetGame()
        }else{
            self.panda.jump()
        }
    }
    
    //每一帧都会执行一次
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if self.gameState == .gameRun{
            self.distance += self.moveSpeed
            self.scoreLabel.text = "🐷🐷🐷🐷🐷🐷:\(self.distance)分数:\(self.score)"
            
            var speed : CGFloat = self.moveSpeed
            if self.distance >= GameSource.a {
                speed = GameSource.speedA
            }
            if self.distance >= GameSource.b{
                speed = GameSource.speedB
            }
            if self.distance >= GameSource.c{
                speed = GameSource.speedC
            }
            if self.distance >= GameSource.d{
                speed = GameSource.speedD
            }
            
            self.moveSpeed = speed
        }
        
        self.lastDis -= self.moveSpeed
        if self.lastDis <= self.self.frame.size.height{
            self.platformFactory.createPlatformRandom()
        }
        self.platformFactory.move(speed: self.moveSpeed)
        
        self.nearPlatform.move(speed: self.moveSpeed / 5.0)
        self.distantPlatform.move(speed: self.moveSpeed / 10.0)
    }
    
    func updateDis(lastDis: CGFloat) {
        self.lastDis = lastDis
        self.panda.position = CGPoint(x: -PJGameWidth + 10, y: self.panda.position.y)
    }
    
    /// MARK: 物理系统代理
    func didBegin(_ contact: SKPhysicsContact) {
        //碰撞了
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskType.panda | BitMaskType.scene{
            self.isFirstStart = !self.isFirstStart
            if self.isFirstStart{
                self.gameOverLabel.isHidden = true
            }else{
                self.gameOver()
            }
        }else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskType.panda | BitMaskType.platform{
            self.panda.run()
            if (self.moveSpeed - GameSource.speedB) >= 0{
                self.platformFactory.midCount = 2
                self.platformFactory.M = 80
                contact.bodyB.isDynamic = true
                contact.bodyB.allowsRotation = true
            }
        }else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskType.panda | BitMaskType.apple{
            if contact.bodyB.categoryBitMask == BitMaskType.apple{
                contact.bodyB.node?.removeFromParent()
            }else{
                contact.bodyA.node?.removeFromParent()
            }
            self.score += 10
            self.scoreLabel.text = "🐷🐷🐷🐷🐷🐷:\(self.distance)分数:\(self.score)"
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskType.panda | BitMaskType.scene{
            self.isFirstStart = !self.isFirstStart
            if self.isFirstStart{
                self.gameOverLabel.isHidden = true
            }else{
                self.gameOver()
            }
        }
    }
}
