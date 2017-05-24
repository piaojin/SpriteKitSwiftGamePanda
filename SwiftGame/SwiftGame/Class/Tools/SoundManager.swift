//
//  SoundManager.swift
//  SwiftGame
//
//  Created by 飘金 on 2017/5/23.
//  Copyright © 2017年 piaojin. All rights reserved.
//

import SpriteKit
import AVFoundation


class SoundManager: SKNode {
    //申明一个播放器
    var bgMusicPlayer = AVAudioPlayer()
    
    //播放炸弹爆炸的动作音效
    let boomAct = SKAction.playSoundFileNamed("boom.mp3", waitForCompletion: false)
    
    //播放撞击草快的动作音效
    let hitPlatformAct = SKAction.playSoundFileNamed("hit_platform.mp3", waitForCompletion: false)
    
    //播放从草快跳跃起来的动作音效
    let jumpFromPlatformAct = SKAction.playSoundFileNamed("jump_from_platform.mp3", waitForCompletion: false)
    
    //播放跳跃在空中的动作音效
    let flyAct = SKAction.playSoundFileNamed("fly.mp3", waitForCompletion: false)
    
    //播放吃到苹果的动作音效
    let eatAppleAct = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    //播放游戏结束的动作音效
    let loseAct = SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false)
    
    //播放升龙拳的动作音效
    let firePunchAct = SKAction.playSoundFileNamed("firePunch.m4a", waitForCompletion: false)
    
    //播放背景音乐的音效
    func playBackGround(){
        //获取bg.mp3文件地址
        guard let bgMusicURL = Bundle.main.url(forResource: "background", withExtension: "mp3") else{
            return
        }
        //根据背景音乐地址生成播放器
        do {
            try bgMusicPlayer = AVAudioPlayer (contentsOf: bgMusicURL)
            //设置为循环播放
            bgMusicPlayer.numberOfLoops = -1
            //准备播放音乐
            bgMusicPlayer.prepareToPlay()
            //播放音乐
            bgMusicPlayer.play()
        } catch  {
            debugPrint("播放背景音乐出错:\(error)")
        }
    }
    
    func playHitPlatform(){
        self.run(self.hitPlatformAct)
    }
    
    func playJumpFromPlatform(){
        self.run(self.jumpFromPlatformAct)
    }
    
    func playFly(){
        self.run(self.flyAct)
    }
    
    func playLose(){
        self.run(self.loseAct)
    }
    
    func playEatApple(){
        self.run(self.eatAppleAct)
    }
    
    func playBoom(){
        self.run(self.boomAct)
    }
    
    func playFirePunch(){
        self.run(self.firePunchAct)
    }
}
