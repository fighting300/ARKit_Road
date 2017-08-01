//
//  QARVideo.swift
//  TripStickyInScene
//
//  Created by Leon on 2017/6/30.
//  Copyright © 2017年 leon. All rights reserved.
//
// 音视频
import Foundation
import SceneKit
import SpriteKit
import AVFoundation

class QARVideo {
    static func startWith(url: NSURL) -> SKVideoNode {
        let videoUrl = Bundle.main.url(forResource: "Coin", withExtension: "mp3")!
        let videoPlayer = AVPlayer(url: videoUrl)
        
        // To make the video loop
        videoPlayer.actionAtItemEnd = .none
        
        // Create the SpriteKit video node, containing the video player
        let videoSpriteKitNode = SKVideoNode(avPlayer: videoPlayer)
        videoSpriteKitNode.yScale = -1.0
        return videoSpriteKitNode;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
