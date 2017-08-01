//
//  ViewController.swift
//  QRoad
//
//  Created by Leon on 2017/6/25.
//  Copyright © 2017年 leon. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, ARSessionObserver, UIGestureRecognizerDelegate, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var lineColor = UIColor.yellow
    var previousPoint: SCNVector3?
    var startNode:SCNNode?
    var endNode:SCNNode?
    var tmpPlanceNode:SCNNode?
    var lineNode:SCNNode?
    var currentLineNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        self.setupScence()
        self.setupFocusSquare()
        self.setupPoint()
    }
    
    let session = ARSession()
    var sessionConfig: ARSessionConfiguration!
    var planeNode: SCNNode!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ARWorldTrackingSessionConfiguration.isSupported {
            // checks if user's device supports the more precise ARWorldTrackingSessionConfiguration
            // Create a session configuration
            let configuration = ARWorldTrackingSessionConfiguration()
            configuration.planeDetection = .horizontal
            configuration.isLightEstimationEnabled = true
            sessionConfig = configuration
            // Run the view's session
            sceneView.session.run(configuration)
        } else {
            // slightly less immersive AR experience due to lower end processor
            let configuration = ARSessionConfiguration()
            sessionConfig = configuration
        }
        sessionConfig.worldAlignment = .gravityAndHeading
        // Run the view's session
        session.run(sessionConfig)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let worldSessionConfig = sessionConfig as? ARWorldTrackingSessionConfiguration {
            worldSessionConfig.planeDetection = .horizontal
            session.run(worldSessionConfig, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    var screenCenter: CGPoint?
    func setupScence() {
        sceneView.delegate = self
        sceneView.session = session
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = false
        
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showFeaturePoints]
        
        DispatchQueue.main.async {
            self.screenCenter = self.sceneView.bounds.mid
        }
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
        }
        
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        
        // 添加手势
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0
        tap.cancelsTouchesInView = false
        self.sceneView.addGestureRecognizer(tap)
        
    }
    
    // called by gesture recognizer
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        
        // handle touch down and touch up events separately
        if gesture.state == .began {
            // do something...
        } else if gesture.state == .ended { // optional for touch up event catching
            // do something else...
        }
    }
    
    
    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // 划线
        /**
        guard let pointOfView = sceneView.pointOfView else { return }
        guard let currentFrame = sceneView.session.currentFrame else { return }

        let mat = SCNMatrix4FromMat4(currentFrame.camera.transform)
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        let currentPosition = pointOfView.position+(dir*0.1)
        if let previousPoint = previousPoint {
            let line = lineFrom(vector: previousPoint, toVector: currentPosition)
            let lineNode = SCNNode(geometry: line)
            lineNode.geometry?.firstMaterial?.diffuse.contents = lineColor
            sceneView.scene.rootNode.addChildNode(lineNode)
        }
        previousPoint = currentPosition
        glLineWidth(20)
        **/
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //let currentPlaneArray = sceneView.hitTest(CGPoint.init(x: 180, y: 325), types: .existingPlaneUsingExtent)
        //print("currentPlaneArray", currentPlaneArray)
        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
        // 获取扫描到的图片
        self.scanInfo()
    }
    
    // 添加节点时候调用（当开启平地捕捉模式之后，如果捕捉到平地，ARKit会自动添加一个平地节点）
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.tmpPlanceNode?.removeFromParentNode()
                NSLog("====%@", anchor)
                let planeBox = SCNBox.init(width: CGFloat(planeAnchor.extent.x*0.2), height: CGFloat(0.06), length: CGFloat(planeAnchor.extent.x*0.2), chamferRadius: CGFloat(0))
                planeBox.firstMaterial?.diffuse.contents = UIColor.blue
                // add texture
                let material = SCNMaterial()
                material.diffuse.contents = UIImage(named: "galaxy")
                let planeNode = SCNNode(geometry: planeBox)
                planeNode.geometry?.materials = [material,material,material,material,material,material]
                planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
                self.tmpPlanceNode = planeNode
                node.addChildNode(planeNode)
                
                self.addPlane(node: node, anchor: planeAnchor)
                /*
                let scene = SCNScene(named: "art.scnassets/ship.scn")!
                let shipNode = scene.rootNode.childNodes[0]
                shipNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
                node.addChildNode(shipNode)
                */
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        NSLog("刷新中")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        NSLog("节点更新")
        DispatchQueue.main.async {
            //            if let planeAnchor = anchor as? ARPlaneAnchor {
            //                self.updatePlane(anchor: planeAnchor)
            //            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        NSLog("节点移除")
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.removePlane(anchor: planeAnchor)
            }
        }
    }
    
    
    // MARK: - ARSessionDelegate
    // 会话位置更新（监听相机的移动），此代理方法会调用非常频繁，只要相机移动就会调用，如果相机移动过快，会有一定的误差，具体的需要强大的算法去优化
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        NSLog("相机移动")
        //        DispatchQueue.main.async {
        //            self.planeNode.position = SCNVector3Make(frame.camera.transform.columns.3.x,frame.camera.transform.columns.3.y,frame.camera.transform.columns.3.z)
        //        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        NSLog("添加锚点")
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        NSLog("刷新锚点")
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        NSLog("移除锚点")
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("touch began")
        DispatchQueue.main.async {
            self.startNode?.removeFromParentNode()
            guard let screenCenter = self.screenCenter else { return }
            
            let (worldPos, _, _) = self.worldPositionFromScreenPosition(screenCenter, objectPos: self.focusSquare?.position)
            if let worldPos = worldPos {
                print("worldPos begin", worldPos)
                
                let scene = SCNScene(named: "art.scnassets/ship.scn")!
                let shipNode = scene.rootNode.childNodes[0]
                self.startNode = shipNode
                shipNode.scale = SCNVector3Make(0.02, 0.02, 0.02)
                shipNode.position = worldPos
                for node in shipNode.childNodes {
                    node.scale = SCNVector3Make(0.02, 0.02, 0.02)
                    shipNode.position = worldPos
                }
                self.sceneView.scene.rootNode.addChildNode(shipNode)
            }
        }

        NSLog("current Frame = %@", session.currentFrame!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("touch and  move")
        DispatchQueue.main.async {
            self.currentLineNode?.removeFromParentNode()
            guard let screenCenter = self.screenCenter else { return }
            guard let currentFrame = self.sceneView.session.currentFrame else { return }
            
            let mat = SCNMatrix4(currentFrame.camera.transform)
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
            
            let (currentPosition, _ , _) = self.worldPositionFromScreenPosition(screenCenter, objectPos: self.focusSquare?.position)
            let previousPoint = self.startNode?.position
            
            let line = self.lineFrom(vector: previousPoint!, toVector: (currentPosition!+dir*0.1))
            let lineNode = SCNNode(geometry: line)
            self.currentLineNode = lineNode
            lineNode.geometry?.firstMaterial?.diffuse.contents = self.lineColor
            self.sceneView.scene.rootNode.addChildNode(lineNode)
            glLineWidth(50)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("touch end")
        DispatchQueue.main.async {
            if let camera = self.sceneView.session.currentFrame?.camera  {
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -0.2
                
                // 在当前的摄像头的位置添加一个
                let transform = matrix_multiply(camera.transform, translation)
                
                // 在世界坐标系中添加的位置
                let position = SCNVector3.positionFromTransform(transform)
                let node = self.textNode()
                node.position = position
                self.sceneView.scene.rootNode.addChildNode(node)
                
                let lightNode = QARLight.init(type: .spot, targets: node, color: nil, position: nil)
                self.sceneView.scene.rootNode.addChildNode(lightNode)
            }
            
            self.endNode?.removeFromParentNode()
            guard let screenCenter = self.screenCenter else { return }

            let (worldPos, _, _) = self.worldPositionFromScreenPosition(screenCenter, objectPos: self.focusSquare?.position)
            guard let previousPoint = self.startNode?.position else { return }
            let length = (worldPos! - previousPoint).length()

            print("lenght", length)
            if let worldPos = worldPos {
                print("worldPos end", worldPos)
                guard let currentFrame = self.sceneView.session.currentFrame else { return }
                let mat = SCNMatrix4(currentFrame.camera.transform)
                let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
                self.currentLineNode?.removeFromParentNode()

                let line = self.lineFrom(vector: previousPoint, toVector: (worldPos+dir*0.1))
                let lineNode = SCNNode(geometry: line)
                self.currentLineNode = lineNode
                lineNode.geometry?.firstMaterial?.diffuse.contents = self.lineColor
                self.sceneView.scene.rootNode.addChildNode(lineNode)
                glLineWidth(50)
                
                let scene = SCNScene(named: "art.scnassets/ship.scn")!
                let shipNode = scene.rootNode.childNodes[0]
                self.endNode = shipNode
                shipNode.scale = SCNVector3Make(0.02, 0.02, 0.02)
                shipNode.position = worldPos
                for node in shipNode.childNodes {
                    node.scale = SCNVector3Make(0.02, 0.02, 0.02)
                    shipNode.position = worldPos
                }
                self.sceneView.scene.rootNode.addChildNode(shipNode)
            }
        }
        
        
    }
    // MARK: -- other function
    // MARK: - Planes
    
    var planes = [ARPlaneAnchor: Plane]()
    
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        
        let pos = SCNVector3.positionFromTransform(anchor.transform)
        NSLog("NEW SURFACE DETECTED AT \(pos.friendlyString())")
        let plane = Plane(anchor, true)
        
        planes[anchor] = plane
        node.addChildNode(plane)
    }
    
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
    
    func removePlane(anchor: ARPlaneAnchor) {
        if let plane = planes.removeValue(forKey: anchor) {
            plane.removeFromParentNode()
        }
    }
    
    func restartPlaneDetection() {
        // configure session
        if let worldSessionConfig = sessionConfig as? ARWorldTrackingSessionConfiguration {
            worldSessionConfig.planeDetection = .horizontal
            session.run(worldSessionConfig, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    
    // MARK: - Focus Square
    var focusSquare: FocusSquare?
    func setupFocusSquare() {
        focusSquare?.isHidden = true
        focusSquare?.removeFromParentNode()
        focusSquare = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquare!)
    }
    
    func updateFocusSquare() {
        guard let screenCenter = screenCenter else { return }
        
        if planeNode != nil && sceneView.isNode(planeNode!, insideFrustumOf: sceneView.pointOfView!) {
            focusSquare?.hide()
        } else {
            focusSquare?.unhide()
        }
        let (worldPos, planeAnchor, _) = worldPositionFromScreenPosition(screenCenter, objectPos: focusSquare?.position)
        if let worldPos = worldPos {
            focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.session.currentFrame?.camera)
        }
    }
    
    // 获取屏幕响应位置对应三位空间的节点
    var dragOnInfinitePlanesEnabled = false
    
    func worldPositionFromScreenPosition(_ position: CGPoint,
                                         objectPos: SCNVector3?,
                                         infinitePlane: Bool = false) -> (position: SCNVector3?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {
        
        // -------------------------------------------------------------------------------
        // 1. Always do a hit test against exisiting plane anchors first.
        //    (If any such anchors exist & only within their extents.)
        
        let planeHitTestResults = sceneView.hitTest(position, types: .existingPlaneUsingExtent)
        if let result = planeHitTestResults.first {
            
            let planeHitTestPosition = SCNVector3.positionFromTransform(result.worldTransform)
            let planeAnchor = result.anchor
            
            // Return immediately - this is the best possible outcome.
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }
        
        // -------------------------------------------------------------------------------
        // 2. Collect more information about the environment by hit testing against
        //    the feature point cloud, but do not return the result yet.
        
        var featureHitTestPosition: SCNVector3?
        var highQualityFeatureHitTestResult = false
        
        let highQualityfeatureHitTestResults = sceneView.hitTestWithFeatures(position, coneOpeningAngleInDegrees: 18, minDistance: 0.2, maxDistance: 2.0)
        
        if !highQualityfeatureHitTestResults.isEmpty {
            let result = highQualityfeatureHitTestResults[0]
            featureHitTestPosition = result.position
            highQualityFeatureHitTestResult = true
        }
        
        // -------------------------------------------------------------------------------
        // 3. If desired or necessary (no good feature hit test result): Hit test
        //    against an infinite, horizontal plane (ignoring the real world).
        
        if (infinitePlane && dragOnInfinitePlanesEnabled) || !highQualityFeatureHitTestResult {
            
            let pointOnPlane = objectPos ?? SCNVector3Zero
            
            let pointOnInfinitePlane = sceneView.hitTestWithInfiniteHorizontalPlane(position, pointOnPlane)
            if pointOnInfinitePlane != nil {
                return (pointOnInfinitePlane, nil, true)
            }
        }
        
        // -------------------------------------------------------------------------------
        // 4. If available, return the result of the hit test against high quality
        //    features if the hit tests against infinite planes were skipped or no
        //    infinite plane was hit.
        
        if highQualityFeatureHitTestResult {
            return (featureHitTestPosition, nil, false)
        }
        
        // -------------------------------------------------------------------------------
        // 5. As a last resort, perform a second, unfiltered hit test against features.
        //    If there are no features in the scene, the result returned here will be nil.
        
        let unfilteredFeatureHitTestResults = sceneView.hitTestWithFeatures(position)
        if !unfilteredFeatureHitTestResults.isEmpty {
            let result = unfilteredFeatureHitTestResults[0]
            return (result.position, nil, false)
        }
        
        return (nil, nil, false)
    }
    
    func setupPoint() {
        let planeBox = SCNPlane.init(width: CGFloat(0.2), height: CGFloat(0))
        planeBox.firstMaterial?.diffuse.contents = UIColor.yellow
        let planeNode = SCNNode(geometry: planeBox)
        sceneView.scene.rootNode.addChildNode(planeNode)
    }
    
    func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
    
    // 图文解析
    func scanInfo() {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        if let cvPixelBuffer = (sceneView.session.currentFrame?.capturedImage) {
            let image = CIImage(cvPixelBuffer: cvPixelBuffer)
            let features = detector?.features(in: image, options: [CIDetectorImageOrientation:8])
            for feature in features! {
                let tmpFeature = feature as! CIQRCodeFeature
                
                let degree = angleBetweenPoints(first: tmpFeature.topRight, second: tmpFeature.topLeft)
                print("degree",degree)
            }
        }
    }
    
    
    // 获取用户方向
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    // MARK: textNode
    func textNode() -> SCNNode {
        let node = QARText.init(string: "leon", depth: 0.02)
        node.scale = SCNVector3Make(0.02, 0.02, 0.02)
        return node
    }
    
}
