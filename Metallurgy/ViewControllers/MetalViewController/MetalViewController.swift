//
//  MetalViewController.swift
//  Metallurgy
//
//  Created by Geir-Kåre S. Wærp on 09/03/2022.
//

import Foundation
import UIKit
import Metal

class MetalViewController: UIViewController {
    let device: MTLDevice
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(metalDevice: MTLDevice) {
        device = metalDevice
        super.init(nibName: nil, bundle: nil)
    }
}
