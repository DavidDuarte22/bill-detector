//
//  SecurityMeasure.swift
//  Bill Detector
//
//  Created by Nahuel Díaz on 27/05/2018.
//  Copyright © 2018 Martin Saporiti. All rights reserved.
//

import Foundation
import ARKit
import SpriteKit

struct SecurityMeasure{
    
    var name: String!
    var position: Position
    var imgType: UIImage
    var videoType: SKScene?
    let width: CGFloat
    let height: CGFloat
//    var material: S
    
    struct AspectRatio {
        static let width: CGFloat = 320
        static let height: CGFloat = 240
    }
    let AspectDiv: CGFloat = 1000
    
    private func convertToMetersFromMilimiters (_ milimiters: Float) ->Float {
        return milimiters/1000
    }
    
    func getSecurityNode() -> SCNNode {
        
        let securityNode = SCNNode(geometry: SCNPlane(width: self.width, height: self.height))
        let z = convertToMetersFromMilimiters(self.position.z)
        let x = convertToMetersFromMilimiters(self.position.x)
        securityNode.position = SCNVector3(x, position.y, z)
        securityNode.geometry?.firstMaterial?.isDoubleSided = true
        securityNode.eulerAngles = SCNVector3(-70.degreesToRadians, 0, 0)
        
        if let spriteKitScene = videoType  {
            // create AVPlayer
            // place AVPlayer on SKVideoNode
//            let playerNode = SKVideoNode(avPlayer: video)
//            // flip video upside down
//            playerNode.yScale = -1
//            // create SKScene and set player node on it
//            let spriteKitScene = SKScene(size: CGSize(width: AspectRatio.width, height: AspectRatio.height))
//            //spriteKitScene.scaleMode = .aspectFit
//            playerNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
//            playerNode.size = spriteKitScene.size
//            spriteKitScene.addChild(playerNode)
//            // create 3D SCNNode and set SKScene as a material
           
            //videoNode.geometry = SCNPlane(width: self.width, height: self.height)
            securityNode.geometry?.firstMaterial?.diffuse.contents = spriteKitScene
//            playerNode.play()
//            if playerNode.isPaused {
//                print("pausado")
//            }
            // place SCNNode inside ARKit 3D coordinate space
            
            
            return securityNode
            //node.addChildNode(videoNode)
            // set the scene to the view
            //self.sceneView.scene = scene
            
        }
        
        securityNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: self.name)
        
        return securityNode

    }
    
    
   // func getSecurityVideo() -> 
    
    struct Position {
        let x: Float!
        let y: Float = 0.02
        let z: Float!
        
    }
}
