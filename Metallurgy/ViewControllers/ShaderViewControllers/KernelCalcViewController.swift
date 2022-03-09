//
//  KernelCalcViewController.swift
//  Metallurgy
//
//  Created by Geir-Kåre S. Wærp on 09/03/2022.
//

import Foundation
import UIKit
import Metal

class KernelCalcViewController: MetalViewController {
    // MARK: Variables
    private let arraySize = 64
    private lazy var arrayA = createRandomArray()
    private lazy var arrayB = createRandomArray()
    private var result: [Float] = []
    
    // MARK: Metal Variables
    private var metalLibrary: MTLLibrary!
    private var addFunction: MTLFunction!
    private var pipeline: MTLComputePipelineState!
    private var commandQueue: MTLCommandQueue!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        result = addArrays(a: arrayA, b: arrayB)
        
        setupUI()
        setupMetal()
    }
    
    // MARK: - UI Helpers
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Kernel Calculations"
    }
    
    // MARK: - Metal Setup
    private func setupMetal() {
        metalLibrary = device.makeDefaultLibrary()!
        addFunction = metalLibrary.makeFunction(name: "add_arrays")!
        pipeline = try! device.makeComputePipelineState(function: addFunction)
        commandQueue = device.makeCommandQueue()
        
        let bufferA = device.makeBuffer(bytes: &arrayA, length: arraySize * MemoryLayout<Float>.size, options: .storageModeShared)!
        let bufferB = device.makeBuffer(bytes: &arrayB, length: arraySize * MemoryLayout<Float>.size, options: .storageModeShared)!
        let bufferResult = device.makeBuffer(length: MemoryLayout<Float>.size * arraySize, options: .storageModeShared)!
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let computeCommandEncoder = commandBuffer.makeComputeCommandEncoder()!
        computeCommandEncoder.setComputePipelineState(pipeline)
        computeCommandEncoder.setBuffer(bufferA, offset: 0, index: 0)
        computeCommandEncoder.setBuffer(bufferB, offset: 0, index: 1)
        computeCommandEncoder.setBuffer(bufferResult, offset: 0, index: 2)
        
        let gridSize = MTLSize(width: arraySize, height: 1, depth: 1)
        
        let threadGroupWidth = min(pipeline.maxTotalThreadsPerThreadgroup, arraySize)
        let threadGroupSize = MTLSize(width: threadGroupWidth, height: 1, depth: 1)
        
        computeCommandEncoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadGroupSize)
        computeCommandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        verifyResults(a: bufferResult, b: result)
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
    
    private func verifyResults(a: MTLBuffer, b: [Float]) {
        let a2 = a.contents().assumingMemoryBound(to: Float.self)
        for i in 0..<arraySize {
            assert(a2[i] == b[i])
        }
    }
}
