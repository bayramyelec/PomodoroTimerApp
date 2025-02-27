//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 26.02.2025.
//

import UIKit

class TabbarController: UIViewController, CustomTabBarDelegate {
    
    let tabbar = MainTabbarView()
    
    private let VC1 = UINavigationController(rootViewController: HomeVC())
    private let VC2 = UINavigationController(rootViewController: ListVC())
    
    private var currentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        view.backgroundColor = .back
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        tabbar.delegate = self
        view.addSubview(tabbar)
        NSLayoutConstraint.activate([
            tabbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabbar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        showVC(vc: VC1)
    }
    
    private func showVC(vc: UIViewController) {
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(vc.view, belowSubview: tabbar)
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        vc.didMove(toParent: self)
        currentVC = vc
    }
    
    func didSelectTabBarItem(at index: Int) {
        switch index {
        case 0: showVC(vc: VC1)
        case 1: showVC(vc: VC2)
        default:
            break
        }
    }
    
}

#Preview {
    TabbarController()
}
