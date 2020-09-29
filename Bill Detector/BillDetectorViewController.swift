//
//  BillDetectorViewController.swift
//  Bill Detector
//
//  Created by Martin Saporiti on 10/05/2018.
//  Copyright © 2018 Martin Saporiti. All rights reserved.
//

import UIKit
import ARKit
import Lottie

class BillDetectorViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let billDetectorModelView: BillDetectorModelView = BillDetectorModelView()
    var cont: Int = 0
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 1
    
    let image_500 = "yaguarete"
    let image_100 = "evita"
    let image_10 = "belgrano"
    let image_1000 = "hornero"
    
    var imageBill: String?
    var nodeBill: SCNNode?
    
    @IBOutlet weak var imagenReset: UIButton!
    @IBOutlet weak var imagenValor: UIImageView!
    
    var sceneLight:SCNLight!
    var planeGeometry: SCNPlane!
    
    var timer: Timer?
    
    var nodesDict = [SCNNode: SCNNode]()
    
    var animationView: LOTAnimationView?
    let animationBill = LOTAnimationView(name: "enfocar")
    
    let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
    struct AspectRatio {
        static let width: CGFloat = 320
        static let height: CGFloat = 240
    }
    let AspectDiv: CGFloat = 1000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        configuration.isLightEstimationEnabled = true
        
        self.animationBill.center = self.view.center
        
        self.view.addSubview(self.animationBill)
        self.animationBill.loopAnimation = true
        self.animationBill.play()
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//       let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))

//       self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
//        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Run the view's session
        self.sceneView.session.run(configuration)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.resetTrackingConfiguration()
    }

    @IBAction func reset(_ sender: Any) {
        resetTrackingConfiguration()
    }

    func resetTrackingConfiguration() {
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        self.timer?.invalidate()
        self.nodeBill?.removeFromParentNode()
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        self.view.addSubview(self.animationBill)
        self.animationBill.loopAnimation = true
        self.animationBill.play()
        self.imagenValor.isHidden = true
        self.imagenReset.isHidden = true
        
    }
    
}



extension BillDetectorViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
    
   
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("BILLETEEEEEE")
        guard let imageAnchor = anchor as? ARImageAnchor,
            let imageName = imageAnchor.referenceImage.name else { return }
        
        DispatchQueue.main.async {
            
            
            self.imageBill = imageName
            self.nodeBill = node
            
            self.animationBill.removeFromSuperview()
            self.setAnimationView(animation: imageName)
            
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animationView?.stop()
            
            
            
            
            

//
            
            
            self.sceneLight = SCNLight()
            self.sceneLight.type = .omni
            
            let lightNode = SCNNode()
            lightNode.light = self.sceneLight
            lightNode.position = SCNVector3(x:0, y:10, z:2)
            
            
            let bill = self.billDetectorModelView.getBillWith(name: self.imageBill!)
            
            for securityMeasure: SecurityMeasure in bill.securityMeasures! {
                let nodoSeguridad = securityMeasure.getSecurityNode()
                
                if let nodoAnillo = self.addNode(vector: securityMeasure.getSecurityNode().position, anillo: securityMeasure.imgType) {
                    self.nodesDict [nodoAnillo] = nodoSeguridad
                    node.addChildNode(nodoAnillo)
                    node.addChildNode(lightNode)
                    
                    //self.nodesDict[SecurityMeasure] = [SecurityMeasure:securityMeasure.getSecurityNode()]
                }
                
                //node.addChildNode(securityMeasure.getSecurityNode())
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.animation), userInfo: nil, repeats: true)
            self.imagenValor.isHidden = false
            self.imagenReset.isHidden = false
            if let label = self.imageBill {
                self.imagenValor.image = UIImage(named: "label\(label)")
            }
            
        }
    }
    
    func setAnimationView (animation: String) {
        self.animationView = LOTAnimationView(name: animation)
        self.animationView?.center = self.view.center
        self.view.addSubview(self.animationView!)
        self.animationView?.play()
    }
    
    func addNode (vector: SCNVector3, anillo: UIImage) -> SCNNode? {
        let node = SCNNode(geometry: SCNTube(innerRadius: 0.0001, outerRadius: 0.005, height: 0.00001))
        //let node = SCNNode(geometry: SCNCylinder(radius: 0.02, height: 0.01))
        node.geometry?.firstMaterial?.diffuse.contents = anillo
        node.position = vector
        return node
    }

    @objc func animation () {
        for (node, _) in self.nodesDict {
            if (node.geometry?.elementCount == 4) {
                DispatchQueue.main.async {
                    let action = SCNAction.scale(by: 1.3, duration: 0.5)
                    node.runAction(action)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let action2 = SCNAction.scale(by: 1/1.3, duration: 0.5)
                    node.runAction(action2)
                }
            }
            
        }
    }
//    @objc func pinch (sender: UIPinchGestureRecognizer) {
        
//        let sceneView = sender.view as! SCNView
//        let pinchLocation = sender.location(in: sceneView)
//        let hitTest = sceneView.hitTest(pinchLocation)
//        print("No pinchaste el objeto")
//        if !hitTest.isEmpty {
//            print("pinchaste el objeto")
//            let results = hitTest.first!
//            let node = results.node
//            print(sender.scale)
//            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
//            node.runAction(pinchAction)
//            sender.scale = 1.0
//        }
//    }
    
//    @objc func handleTap (sender: UITapGestureRecognizer) {
//        let sceneViewTappedOn = sender.view as! SCNView
//        let touchCoordenades = sender.location(in: sceneViewTappedOn)
//        let hitTest = sceneViewTappedOn.hitTest(touchCoordenades)
//        print("coordenadas: ")
//        print(hitTest)
////        if hitTest.isEmpty {
////            print("no tocaste ningun objeto")
////        } else {
////            print("acertaste. Posicion: ")
////            let results = hitTest.first!
////            print(results.node.position)
////            removeNode(node: results.node)
////        }
//    }
    
    func removeNode (node: SCNNode) {
        node.removeFromParentNode()
        self.nodeBill?.addChildNode(self.nodesDict[node]!)
        self.nodesDict [self.nodesDict[node]!] = node
        if let removedValue = self.nodesDict.removeValue(forKey: node) {
            print("El nodo removido es \(removedValue).")
        } else {
            print("No existe ese nodo.")
        }
    }
   
    /**
        Crea un plano (SCNPlane sobre el billete reconocido.
        * Parameters:
            + image - imágen reconocida (el billete)
     
        * Returns
            SCNPlane
     */
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
    
//    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//    {
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self.sceneView];
//    SCNHitTestResult *hitTestResult = [[self.sceneView hitTest:touchPoint options:nil] firstObject];
//    SCNNode *hitNode = hitTestResult.node;
//    [hitNode removeFromParentNode];
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchPoint: CGPoint = touch.location(in: self.sceneView)
        let hitTest = sceneView.hitTest(touchPoint)
        if hitTest.isEmpty {
            print("no tocaste ningun objeto")
        } else {
            let results = hitTest.first!
            removeNode(node: results.node)
        }
        
    }
    
    
}


extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}


