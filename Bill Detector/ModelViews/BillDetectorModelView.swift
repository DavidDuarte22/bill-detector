//
//  BillDetectorModelView.swift
//  Bill Detector
//
//  Created by Nahuel Díaz on 28/05/2018.
//  Copyright © 2018 Martin Saporiti. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class BillDetectorModelView: NSObject {
    
    
//    enum BillTypes -> String {
//        case <#case#>
//    }
    
    func getBillWith (name: String) -> Bill {
        switch name {
        case "1000":
            return horneroBillConfiguration()
        case "500":
            return jaguareteBillConfiguration()
        default:
            return defaultBillConfiguration(name)
        }
    }
    
    
    
    private func defaultBillConfiguration(_ name:String) -> Bill {
        let securityMeasures: [SecurityMeasure] = []
        let defaultBill: Bill = Bill(name: name, image: UIImage(imageLiteralResourceName: name), securityMeasures: securityMeasures)
        return defaultBill
    }
    struct AspectRatio {
        static let width: CGFloat = 320
        static let height: CGFloat = 240
    }
    
    func getVideo (video: String) -> SKScene {
        let videoURL = Bundle.main.path(forResource: video, ofType:"mp4")
        let video = AVPlayer(url:URL(fileURLWithPath: videoURL!))
        let playerNode = SKVideoNode(avPlayer: video)
        playerNode.yScale = -1
        let spriteKitScene = SKScene(size: CGSize(width: AspectRatio.width, height: AspectRatio.height))
        playerNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        playerNode.size = spriteKitScene.size
        spriteKitScene.addChild(playerNode)
        playerNode.play()
        return spriteKitScene
    }
    
    private func horneroBillConfiguration ()-> Bill {
        var securityMeasures: [SecurityMeasure] = []
        
        let video = self.getVideo(video: "hornero")
        
        let videoflux = SecurityMeasure(name: "videoFlux", position: SecurityMeasure.Position(x: -5, z: -5), imgType: UIImage(imageLiteralResourceName: "1000anec"), videoType: video, width: 0.0846, height: 0.072)
        securityMeasures.append(videoflux)
        
        let marcaBalanza = SecurityMeasure(name: "1000-seguridad-1", position: SecurityMeasure.Position(x: 23, z: -20), imgType: UIImage(imageLiteralResourceName: "1000seg"), videoType: nil, width: 0.1323, height: 0.033)
        securityMeasures.append(marcaBalanza)
        
        let infoAnecdotica = SecurityMeasure(name: "1000-seguridad-2", position: SecurityMeasure.Position(x: 35, z: 20), imgType: UIImage(imageLiteralResourceName: "1000seg"), videoType: nil, width: 0.1323, height: 0.033)
        securityMeasures.append(infoAnecdotica)

        //Bill Hornero
        let horneroBill: Bill = Bill(name: "1000", image: UIImage(imageLiteralResourceName: "1000"), securityMeasures: securityMeasures)
        return horneroBill
    }
    
    private func jaguareteBillConfiguration() -> Bill {
        var securityMeasures: [SecurityMeasure] = []
    
        let video = self.getVideo(video: "yaguarete")
        
        let videoYaguarete = SecurityMeasure(name: "videoYaguarete", position: SecurityMeasure.Position(x: -10, z: 15), imgType: UIImage(imageLiteralResourceName: "500anec"), videoType: video, width: 0.0846, height: 0.072)
        securityMeasures.append(videoYaguarete)
        
        let marcaSeguridad = SecurityMeasure(name: "500-seguridad-2", position: SecurityMeasure.Position(x: 35, z: -17), imgType: UIImage(imageLiteralResourceName: "500seg"), videoType: nil, width: 0.1323, height: 0.033)
            securityMeasures.append(marcaSeguridad)
        
        //let infoAnecdotica = SecurityMeasure(name: "500-seguridad-1", position: SecurityMeasure.Position(x: -53, z: 0), imgType: UIImage(imageLiteralResourceName: "500seg"), videoType: nil, width: 0.0846, height: 0.072)
        let infoAnecdotica = SecurityMeasure(name: "500-seguridad-1", position: SecurityMeasure.Position(x: -53, z: 0), imgType: UIImage(imageLiteralResourceName: "500seg"), videoType: nil, width: 0.1323, height: 0.033)
            securityMeasures.append(infoAnecdotica)
        
        
        let jaguareteBill: Bill = Bill(name: "500", image: UIImage(imageLiteralResourceName: "500"), securityMeasures: securityMeasures)
        return jaguareteBill
    }
}
