//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 26.02.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var segmentedController: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Focus", "Break"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = .systemYellow.withAlphaComponent(0.6)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    let customView = CustomBackView(frame: .zero)
    let customView2 = CustomBackView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .back
        
        view.addSubview(segmentedController)
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.alpha = 1
        view.addSubview(customView)
        
        customView2.translatesAutoresizingMaskIntoConstraints = false
        customView2.alpha = 0
        view.addSubview(customView2)
        
        NSLayoutConstraint.activate([
            
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedController.heightAnchor.constraint(equalToConstant: 30),
            segmentedController.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            
            customView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 10),
            customView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            customView2.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 10),
            customView2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            customView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            customView2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func handleSegmentedControlValueChanged(){
        if segmentedController.selectedSegmentIndex == 0 {
            customView.alpha = 1
            customView2.alpha = 0
        } else if segmentedController.selectedSegmentIndex == 1 {
            customView.alpha = 0
            customView2.alpha = 1
        }
    }
    
}


#Preview {
    ViewController()
}
