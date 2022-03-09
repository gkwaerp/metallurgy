//
//  KernelCalcViewController.swift
//  Metallurgy
//
//  Created by Geir-Kåre S. Wærp on 09/03/2022.
//

import Foundation
import UIKit

class KernelCalcViewController: UIViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - UI Helpers
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Kernel Calculations"
    }
}
