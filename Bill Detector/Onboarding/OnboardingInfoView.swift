//
//  OnboardingInfoView.swift
//  Bill Detector
//
//  Created by David Duarte on 31/8/18.
//  Copyright © 2018 Martin Saporiti. All rights reserved.
//

import UIKit

protocol OnboardingDelegate {
    func onboardingOnTouch()
}

class OnboardingInfoView: UIView {
    
    @IBOutlet weak var onboardingButton: UIButton!
    @IBOutlet weak var onboardingView: UIImageView!
    @IBOutlet weak var onboardingTitle: UILabel!
    
    var delegate: OnboardingDelegate?
    
    
    @IBAction func onboardingOnTouch(_ sender: Any) {
        delegate?.onboardingOnTouch()
    }
    
}
