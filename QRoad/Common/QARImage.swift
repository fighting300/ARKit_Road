//
//  QARImage.swift
//  TripStickyInScene
//
//  Created by Leon on 2017/7/3.
//  Copyright © 2017年 qunar. All rights reserved.
//

import Foundation
import SceneKit

class QARImage : SCNNode {
    init(image: UIImage) {
        super.init()
        let width = CGFloat((image.cgImage?.width)!)
        let height =  CGFloat((image.cgImage?.height)!)
        
        let materil = QARMateril.init(diffuseContent: image, specularContent: nil, emissionContent: nil, shiniess: 1.0)
        let plane = SCNPlane(width:width, height: height)
        plane.materials = [materil]
        
        self.geometry = plane
        self.eulerAngles = SCNVector3Make(Float.pi / 2.0, 0, 0) // Horizontal
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("QARImage init(coder:) has not been implemented")
        
    }
}
