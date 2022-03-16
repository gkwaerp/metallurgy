//
//  MetalViewDrawingViewController.swift
//  Metallurgy
//
//  Created by Geir-Kåre S. Wærp on 15/03/2022.
//

// Based on: https://developer.apple.com/documentation/metal/basic_tasks_and_concepts/using_metal_to_draw_a_view_s_contents

import Foundation
import MetalKit

class MetalViewDrawingViewController: MetalViewController {
    // MARK: - Variables
    private let mtkView: MTKView
    private let renderer: Renderer
    
    // MARK: - Life Cycle
    required init(metalDevice: MTLDevice) {
        mtkView = MTKView()
        mtkView.translatesAutoresizingMaskIntoConstraints = false
        mtkView.device = metalDevice
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        mtkView.enableSetNeedsDisplay = true
        
        renderer = Renderer(device: metalDevice)
        
        super.init(metalDevice: metalDevice)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMetal()
    }
    
    // MARK: - UI Helpers
    private func setupUI() {
        title = "Drawing View Content"
        view.backgroundColor = .systemBackground
        
        view.addSubview(mtkView)
        NSLayoutConstraint.activate([mtkView.topAnchor.constraint(equalTo: view.topAnchor),
                                     mtkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     mtkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     mtkView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func setupMetal() {
        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = renderer
    }
}

// MARK: - Renderer Implementation
fileprivate class Renderer: NSObject, MTKViewDelegate {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        commandEncoder.endEncoding()
        
        let drawable = view.currentDrawable!
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
