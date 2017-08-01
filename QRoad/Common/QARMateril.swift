//
//  QARMateril.swift
//  TripStickyInScene
//
//  Created by Leon on 2017/6/30.
//  Copyright © 2017年 leon. All rights reserved.
//
// 材质辅助类
import Foundation
import SceneKit
import SpriteKit

// diffuse 基础颜色纹理  specular 亮度以及该如何反射光 emission 材料发光时的样子  normal 法向
// 颜色 图像 sprite场景  纹理
class QARMateril: SCNMaterial {
    init(diffuseContent: Any?, specularContent: Any?, emissionContent: Any?, ambientContent: Any?, shiniess: CGFloat ) {
        super.init()
        if (diffuseContent != nil) {
            self.diffuse.contents = diffuseContent
        }
        if (specularContent != nil) {
            self.specular.contents = specularContent
        }
        if (emissionContent != nil) {
            self.emission.contents = emissionContent
        }
        if (ambientContent != nil) {
            self.ambient.contents = ambientContent
        }
        self.shininess = shiniess
        
        //let noiseTexture = SKTexture(noiseWithSmoothness: 0.25, size: CGSize(width: 512, height: 512), grayscale: true)
        //let noiseNormalMapTexture = noiseTexture.textureByGeneratingNormalMapWithSmoothness(1, contrast: 1.0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
