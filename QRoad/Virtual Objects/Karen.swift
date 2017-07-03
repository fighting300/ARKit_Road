//
//  Karen.swift
//  TripStickyInScene
//
//  Created by Leon on 2017/6/28.
//  Copyright © 2017年 qunar. All rights reserved.
//

import Foundation
import SceneKit

class Karen: VirtualObject, ReactsToScale {
    
    override init() {
        super.init()
        //super.init(modelName: "Karen", fileExtension: "dae", thumbImageFilename: "karen", title: "Karen")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reactToScale() {
        // Update the size of the flame
        let flameNode = self.childNode(withName: "flame", recursively: true)
        let particleSize: Float = 0.018
        flameNode?.particleSystems?.first?.reset()
        flameNode?.particleSystems?.first?.particleSize = CGFloat(self.scale.x * particleSize)
    }
}

