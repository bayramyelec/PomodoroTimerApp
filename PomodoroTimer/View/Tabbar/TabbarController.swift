//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 26.02.2025.
//

import UIKit

class TabbarController: UIViewController, CustomTabBarDelegate, ShowPlusButtonDelegate {
    
    let tabbar = MainTabbarView()
    var viewModel = TimerViewModel()
    
    private let VC1: TimerVC = {
        let timerVC = TimerVC()
        return timerVC
    }()
    private let VC2 = UINavigationController(rootViewController: ListVC())
    
    private var currentVC: UIViewController?
    
    private lazy var focusButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "timer", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.backgroundColor = .black.withAlphaComponent(0.2)
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(focusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()
    
    private lazy var breakButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "cup.and.saucer.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.backgroundColor = .black.withAlphaComponent(0.2)
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(breakButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()
    
    private lazy var focusTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(focusTimePickerValueChanged), for: .valueChanged)
        picker.alpha = 0
        picker.backgroundColor = .systemBackground
        picker.layer.cornerRadius = 20
        picker.clipsToBounds = true
        return picker
    }()
    
    private lazy var breakTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(breakTimePickerValueChanged), for: .valueChanged)
        picker.alpha = 0
        picker.backgroundColor = .systemBackground
        picker.layer.cornerRadius = 20
        picker.clipsToBounds = true
        return picker
    }()
    
    private lazy var focusTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Focus Time"
        return label
    }()
    
    private lazy var breakTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Break Time"
        return label
    }()
    
    private var isShowPlusButton: Bool = false
    private var isShowFocusButton: Bool = false
    private var isShowBreakButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupVC1()
    }
    
    private func setup(){
        view.backgroundColor = .back
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        tabbar.delegate = self
        tabbar.plusButtonDelegate = self
        
        view.addSubview(tabbar)
        view.addSubview(focusButton)
        view.addSubview(breakButton)
        view.addSubview(focusTimePicker)
        view.addSubview(breakTimePicker)
        
        focusTimePicker.addSubview(focusTimeLabel)
        breakTimePicker.addSubview(breakTimeLabel)
        
        NSLayoutConstraint.activate([
            tabbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tabbar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            focusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            focusButton.widthAnchor.constraint(equalToConstant: 70),
            focusButton.heightAnchor.constraint(equalToConstant: 70),
            
            breakButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            breakButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            breakButton.widthAnchor.constraint(equalToConstant: 70),
            breakButton.heightAnchor.constraint(equalToConstant: 70),
            
            focusTimePicker.rightAnchor.constraint(equalTo: view.leftAnchor),
            focusTimePicker.bottomAnchor.constraint(equalTo: tabbar.topAnchor, constant: -90),
            focusTimePicker.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            focusTimePicker.heightAnchor.constraint(equalToConstant: screenWidth * 0.3),
            
            breakTimePicker.leftAnchor.constraint(equalTo: view.rightAnchor),
            breakTimePicker.bottomAnchor.constraint(equalTo: tabbar.topAnchor, constant: -90),
            breakTimePicker.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            breakTimePicker.heightAnchor.constraint(equalToConstant: screenWidth * 0.3),
            
            focusTimeLabel.topAnchor.constraint(equalTo: focusTimePicker.topAnchor, constant: 5),
            focusTimeLabel.leftAnchor.constraint(equalTo: focusTimePicker.leftAnchor, constant: 10),
            
            breakTimeLabel.topAnchor.constraint(equalTo: breakTimePicker.topAnchor, constant: 5),
            breakTimeLabel.leftAnchor.constraint(equalTo: breakTimePicker.leftAnchor, constant: 10)
            
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
    
    @objc func focusButtonTapped(){
        isShowFocusButton.toggle()
        isShowBreakButton = false
        if isShowFocusButton {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: []) {
                self.focusTimePicker.transform = CGAffineTransform(translationX: self.screenWidth * 0.75, y: 0)
                self.focusTimePicker.alpha = 1
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3) {
                self.breakTimePicker.transform = .identity
                self.breakTimePicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.focusTimePicker.transform = .identity
                self.focusTimePicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func breakButtonTapped(){
        isShowBreakButton.toggle()
        isShowFocusButton = false
        if isShowBreakButton {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: []) {
                self.breakTimePicker.transform = CGAffineTransform(translationX: -self.screenWidth * 0.75, y: 0)
                self.breakTimePicker.alpha = 1
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3) {
                self.focusTimePicker.transform = .identity
                self.focusTimePicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.breakTimePicker.transform = .identity
                self.breakTimePicker.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func showPlusButtonAnimate() {
        isShowPlusButton.toggle()
        isShowFocusButton = false
        isShowBreakButton = false
        if isShowPlusButton {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                    self.focusButton.transform = CGAffineTransform(translationX: -50, y: -65)
                    self.focusButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                    self.breakButton.transform = CGAffineTransform(translationX: 50, y: -65)
                    self.breakButton.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.animate(withDuration: 0.2) {
                    self.breakTimePicker.transform = .identity
                    self.focusTimePicker.transform = .identity
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                    self.breakButton.transform = .identity
                    self.breakButton.alpha = 0
                    self.view.layoutIfNeeded()
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                    self.focusButton.transform = .identity
                    self.focusButton.alpha = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func focusTimePickerValueChanged(){
        let totalTime = Int(focusTimePicker.countDownDuration)
        viewModel.timerModel.totalTime = totalTime
        VC1.focusTimePicker.countDownDuration = TimeInterval(viewModel.timerModel.totalTime)
        VC1.timerLabel.text = String(format: "%02d:%02d:%02d", viewModel.timerModel.totalTime / 3600, (viewModel.timerModel.totalTime % 3600) / 60, viewModel.timerModel.totalTime % 60)
    }
    
    @objc func breakTimePickerValueChanged(){
        
    }
    
    private func setupVC1(){
        VC1.focusTimePicker = self.focusTimePicker
        VC1.viewModel = viewModel
        viewModel.onTimerUpdate = { [weak self] totalTime in
            self?.VC1.timerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
        }
    }
    
}

#Preview {
    TabbarController()
}
