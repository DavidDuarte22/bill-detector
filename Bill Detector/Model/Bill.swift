//
//  Bill.swift
//  Bill Detector
//
//  Created by Nahuel Díaz on 27/05/2018.
//  Copyright © 2018 Martin Saporiti. All rights reserved.
//

import Foundation
import UIKit
import ARKit

struct Bill {
    
    var name: String!
    var image: UIImage!
//    var type: BillType!
    var securityMeasures: [SecurityMeasure]?
    
    enum BillType {
        case hornero
        case ballena
        case evita
        case malvinas
        case llama
        case belgrano
    }
    
}
