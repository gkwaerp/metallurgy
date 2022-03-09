//
//  ViewController.swift
//  Metallurgy
//
//  Created by Geir-Kåre S. Wærp on 09/03/2022.
//

import UIKit
import Metal

class MainViewController: UIViewController {
    // MARK: - Variables
    private let viewControllers: [MetalViewController.Type] = [
        KernelCalcViewController.self
    ]
    
    private var device: MTLDevice!
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        device = MTLCreateSystemDefaultDevice()!
    }

    // MARK: - UI Helpers
    private func setupUI() {
        title = "Metallurgy"
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        viewControllers.enumerated().forEach { (index, viewController) in
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            let title = viewController.description()
                .replacingOccurrences(of: "Metallurgy.", with: "")
                .replacingOccurrences(of: "ViewController", with: "")
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            stackView.addSubview(button)
        }
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                                     stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                                     stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
                                    ])
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        let viewController = viewControllers[sender.tag].init(metalDevice: device)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

