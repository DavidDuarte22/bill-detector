//
//  OnboardingViewController.swift
//  Bill Detector
//
//  Created by David Duarte on 31/8/18.
//  Copyright © 2018 Martin Saporiti. All rights reserved.
//

import UIKit
import Lottie

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var scrollView = UIScrollView()
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var titlesArray = ["Salala1", "Salala2", "Salala3", "Salala3"]
    
    var animationReconocimiento = LOTAnimationView(name: "reconocimiento")
    var animationArandela = LOTAnimationView(name: "arandelas")
    var animationMarcaAnimada = LOTAnimationView(name: "marca-animada")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadViews()
    }
    
    func loadViews(){
        configurePageControl()
        initializeScrollView()
        
         for index in 0...3 {
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size 
            self.scrollView.isPagingEnabled = true
            
            let viewXib = Bundle.main.loadNibNamed("OnboardingInfoView", owner: nil, options: nil)![0] as! OnboardingInfoView
            viewXib.frame = frame
            viewXib.delegate = self
            viewXib.onboardingButton.isHidden = true
            
            let screenSize: CGRect = UIScreen.main.bounds
            self.animationMarcaAnimada.bounds =  CGRect(x: 0, y: 0, width: screenSize.width/1.2, height: screenSize.height/1.6)
            self.animationReconocimiento.bounds =  CGRect(x: 0, y: 0, width: screenSize.width/1.2, height: screenSize.height/1.6)
            self.animationArandela.bounds =  CGRect(x: 0, y: 0, width: screenSize.width/1.2, height: screenSize.height/1.6)
            // self.animationMarcaAnimada.frame =
            switch index {
            case 0:
                viewXib.onboardingTitle.text = "Descubrí lo que cuentan los billetes"
                self.animationMarcaAnimada.center = viewXib.onboardingView.center
                viewXib.addSubview(self.animationMarcaAnimada)
                self.animationMarcaAnimada.loopAnimation = true
                self.animationMarcaAnimada.play()
            case 1:
                viewXib.onboardingTitle.text = "Enfocá un billete con el lector"
                self.animationReconocimiento.center = viewXib.onboardingView.center
                viewXib.addSubview(self.animationReconocimiento)
                self.animationReconocimiento.loopAnimation = true
            case 2:
                viewXib.onboardingTitle.text = "Presioná los anillos y obtené información del billete"
                self.animationArandela.center = viewXib.onboardingView.center
                viewXib.addSubview(self.animationArandela)
                self.animationArandela.loopAnimation = true
                
            case 3:
                viewXib.onboardingButton.isHidden = false
                viewXib.onboardingView.image = UIImage(named: "onboarding-camara-blanco")
                
            default:
                self.animationMarcaAnimada.center = viewXib.onboardingView.center
                viewXib.addSubview(self.animationMarcaAnimada)
                self.animationMarcaAnimada.loopAnimation = true
                
                //viewXib.onboardingTitle.text = "Titulo 4"
            }
            self.scrollView .addSubview(viewXib)
            
         }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 4, height: self.scrollView.frame.size.height)
        
        pageControl.addTarget(self, action: #selector(changePage(_:)), for: UIControlEvents.valueChanged)
        
        
    }
    
    @objc func changePage(_ sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        print(x)
        controlUserSeeOnboarding(pageControl.currentPage)
        
    }
    
    func configurePageControl() {
        
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.view.addSubview(pageControl)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        controlUserSeeOnboarding(pageControl.currentPage)
    }
    
    func initializeScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - pageControl.frame.size.height - 8))
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
    }
    
    func controlUserSeeOnboarding(_ numberPage: Int){
        switch numberPage {
        case 1:
            self.animationReconocimiento.play()
        case 2:
            self.animationArandela.play()
        default:
            return
        }
        if numberPage == 2 {
            
            //Iniciar Adaptive con parametro de llave de corte
            //AdaptiveHelper.sharedInstance.initSdk()
            
           // LocalDataHelper.setBool(true, forKey: "userSeeOnboarding")
        }
    }
}

extension OnboardingViewController: OnboardingDelegate {
    func onboardingOnTouch() {
        UserDefaults.standard.set("name", forKey: "name")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BillDetectorView") as! BillDetectorViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
}









