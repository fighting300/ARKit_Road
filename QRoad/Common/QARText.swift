//
//  QARText.swift
//  TripStickyInScene
//
//  Created by Leon on 2017/6/30.
//  Copyright © 2017年 leon. All rights reserved.
//
// 文字
import Foundation
import SceneKit

class QARText: SCNNode {
    init (string: String, depth: CGFloat ) {
        super.init()
        let text = SCNText.init(string: string, extrusionDepth: depth)
        
        text.font = UIFont(name: "Arial", size: 1.0)
        text.isWrapped = true
        text.alignmentMode = kCAAlignmentNatural
        text.truncationMode = kCATruncationEnd
        //text.containerFrame = CGRect(x: 0, y: 0, width: 30, height: 20)
        
        text.flatness = 0.5
        text.chamferRadius = 0.3
        text.firstMaterial?.shininess = 0.4
        text.firstMaterial?.diffuse.contents = UIColor.red
        text.firstMaterial?.specular.contents = UIColor.orange
                
        self.geometry = text
        
        //        let material = SCNMaterial()
        //        material.diffuse.contents = UIImage(named: "plane_grid.png")
        //        self.geometry?.materials = [material]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
