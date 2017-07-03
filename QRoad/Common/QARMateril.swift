//
//  QARMateril.swift
//  TripStickyInScene
//
//  Created by Leon on 2017/6/30.
//  Copyright © 2017年 qunar. All rights reserved.
//
// 材质辅助类
import Foundation
import SceneKit
import SpriteKit

// diffuse 基础颜色纹理  specular 亮度以及该如何反射光 emission 材料发光时的样子  normal 法向
// 颜色 图像 sprite场景  纹理
class QARMateril: SCNMaterial {
    init(diffuseContent: Any?, specularContent: Any?, emissionContent: Any?, shiniess: CGFloat ) {
        super.init()
        self.diffuse.contents = diffuseContent
        self.specular.contents = specularContent
        self.emission.contents = emissionContent
        self.shininess = shiniess
        
        //let noiseTexture = SKTexture(noiseWithSmoothness: 0.25, size: CGSize(width: 512, height: 512), grayscale: true)
        //let noiseNormalMapTexture = noiseTexture.textureByGeneratingNormalMapWithSmoothness(1, contrast: 1.0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
