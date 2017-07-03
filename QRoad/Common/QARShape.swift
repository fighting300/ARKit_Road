//
//  QARShape.swift
//  TripStickyInScene
//
//  Created by Leon on 2017/6/30.
//  Copyright © 2017年 qunar. All rights reserved.
//
//
import Foundation
import SceneKit

class QARShape: SCNNode {
    init(withType: NSString) {
        super.init()
    }
    
    class func boxAtom() -> SCNGeometry {
        let boxAtom = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        boxAtom.firstMaterial!.diffuse.contents = UIColor.darkGray
        boxAtom.firstMaterial!.specular.contents = UIColor.white
        return boxAtom
    }
    
    class func sphereAtom() -> SCNGeometry {
        let sphereAtom = SCNSphere(radius: 1.20)
        sphereAtom.firstMaterial!.diffuse.contents = UIColor.lightGray
        sphereAtom.firstMaterial!.specular.contents = UIColor.white
        return sphereAtom
    }
    
    class func cylinderAtom() -> SCNGeometry {
        let cylinderAtom = SCNCylinder(radius: 1.52, height: 1.0)
        cylinderAtom.firstMaterial!.diffuse.contents = UIColor.red
        cylinderAtom.firstMaterial!.specular.contents = UIColor.white
        return cylinderAtom
    }
    
    class func coneAtom() -> SCNGeometry {
        let coneAtom = SCNCone(topRadius: 1.0, bottomRadius: 0.8, height: 1.0)
        coneAtom.firstMaterial!.diffuse.contents = UIColor.yellow
        coneAtom.firstMaterial!.specular.contents = UIColor.white
        return coneAtom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
