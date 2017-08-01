//
//  QARAudio.swift
//  TripStickyInScene
//
//  Created by Leon on 2017/6/30.
//  Copyright © 2017年 leon. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class QARAudio: SCNNode {
    var sounds:[String:SCNAudioSource] = [:]
    
    init(fileName: String, name: String) {
        super.init()
        if let sound = SCNAudioSource(fileNamed: fileName) {
            sound.load()
            sounds[name] = sound
        }
    }
    
    func playSound(node: SCNNode, name: String) {
        let sound = sounds[name]
        node.runAction(SCNAction.playAudio(sound!, waitForCompletion: false))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
