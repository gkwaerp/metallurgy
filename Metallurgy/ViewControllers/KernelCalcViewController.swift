//
//  KernelCalcViewController.swift
//  Metallurgy
//
//  Created by Geir-Kåre S. Wærp on 09/03/2022.
//

import Foundation
import UIKit

class KernelCalcViewController: UIViewController {
    // MARK: Variables
    private let arraySize = 64
    private lazy var arrayA = createRandomArray()
    private lazy var arrayB = createRandomArray()
    private var result: [Float] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        result = addArrays(a: arrayA, b: arrayB)
    }
    
    // MARK: - UI Helpers
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Kernel Calculations"
    }
    
    // MARK: - Logic
    private func addArrays(a: [Float], b: [Float]) -> [Float] {
        guard a.count == b.count else {
            fatalError("Invalid input, must be equal sizes")
        }
        
        var result: [Float] = []
        for i in 0..<a.count {
            result.append(a[i] + b[i])
        }
        
        return result
    }
    
    private func createRandomArray() -> [Float] {
        var array: [Float] = []
        for _ in 0..<arraySize {
            array.append(Float.random(in: -1000...1000))
        }
        return array
    }
}
