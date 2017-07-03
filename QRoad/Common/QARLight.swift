//
//  QARLight.swift
//  TripStickyInScene
//
//  Created by Leon on 2017/6/30.
//  Copyright © 2017年 qunar. All rights reserved.
//
// 灯光
import Foundation
import SceneKit

class QARLight: SCNNode {
    init(type: SCNLight.LightType, targets: SCNNode?) {
        super.init()
        let spot  = SCNLight()
        // ambient 环境光 omin 泛光 direction 平行光 spot 聚光
        spot.type = type
        spot.castsShadow = true
        spot.color = UIColor.red
        self.light = spot
        if let target = targets {
            let lookAt = SCNLookAtConstraint(target: target)
            self.constraints = [lookAt]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
