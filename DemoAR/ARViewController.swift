//
//  ViewController.swift
//  DemoAR
//
//  Created by Jane Wu on 2017/9/23.
//  Copyright © 2017年 Jane Wu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var subNode  : SCNNode?
    var subNodes : [SCNNode] = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/DemoScene.scn")!
        subNode = scene.rootNode.childNode(withName: "text", recursively: true)
        //设定比例
        subNode?.scale = SCNVector3Make(0.001, 0.001, 0.001)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //移除node
        for node in subNodes {
            node.removeFromParentNode()
        }
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: - 手势
    //在手指点击的位置添加node
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let results     = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        
        guard let hitFeature = results.last else { return }
        // 获取到点击位置的3D位置信息（位置、旋转角度、缩放）
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        // 取出位置信息中的坐标信息
        let hitPosition = SCNVector3Make(hitTransform.m41,
                                         hitTransform.m42,
                                         hitTransform.m43)
        
        //add
        let nodeClone = subNode!.clone()
        nodeClone.position = hitPosition
        sceneView.scene.rootNode.addChildNode(nodeClone)
        subNodes.append(nodeClone)

    }
}
