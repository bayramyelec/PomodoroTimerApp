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
    var listViewModel = ListViewModel()
    
    private lazy var VC1: TimerVC = {
        let timerVC = TimerVC(viewModel: viewModel, listViewModel: listViewModel)
        return timerVC
    }()
    
    private let VC2 = UINavigationController(rootViewController: SettingsVC())
    
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
    
    @objc func focusTimePickerValueChanged(_ sender: UIDatePicker){
        let totalTime = sender.countDownDuration
        viewModel.timerModel.totalTime = Int(totalTime)
        viewModel.resetTimer(time: viewModel.timerModel.totalTime)
        VC1.startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        VC1.isShowStopButton = false
        VC1.focusTimePicker.countDownDuration = TimeInterval(viewModel.timerModel.totalTime)
        VC1.focusTimerLabel.text = String(format: "%02d:%02d:%02d", viewModel.timerModel.totalTime / 3600, (viewModel.timerModel.totalTime % 3600) / 60, viewModel.timerModel.totalTime % 60)
        VC1.segmentedController.selectedSegmentIndex = 0
        VC1.timerButtonStackView.isHidden = false
    }
    
    @objc func breakTimePickerValueChanged(_ sender: UIDatePicker){
        let totalTime = sender.countDownDuration
        VC1.breakTimerLabel.text = String(format: "%02d:%02d:%02d", viewModel.timerModel.totalTime / 3600, (viewModel.timerModel.totalTime % 3600) / 60, viewModel.timerModel.totalTime % 60)
        viewModel.timerModel.totalTime = Int(totalTime)
        viewModel.resetTimer(time: viewModel.timerModel.totalTime)
        VC1.startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        VC1.isShowStopButton = false
        VC1.breakTimePicker.countDownDuration = TimeInterval(viewModel.timerModel.totalTime)
        VC1.segmentedController.selectedSegmentIndex = 1
        VC1.timerButtonStackView.isHidden = true
    }
    
    private func setupVC1(){
        VC1.focusTimePicker = self.focusTimePicker
        VC1.breakTimePicker = self.breakTimePicker
        
        VC1.viewModel = viewModel
        VC1.listViewModel = listViewModel
        
        viewModel.onTimerUpdate = { [weak self] totalTime in
            if self?.VC1.segmentedController.selectedSegmentIndex == 0 {
                self?.VC1.focusTimerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
            } else if self?.VC1.segmentedController.selectedSegmentIndex == 1 {
                self?.VC1.breakTimerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
            }
        }
        
        viewModel.onTimerFinish = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if self.viewModel.timerModel.isBreak {
                    self.VC1.segmentedController.selectedSegmentIndex = 0
                    self.viewModel.setBreakMode(false)
                    self.VC1.segmentedControlValueChanged()
                    
                    let focusTime = Int(self.focusTimePicker.countDownDuration)
                    let breakTime = Int(self.breakTimePicker.countDownDuration)
                    print("Adding item - Focus: \(focusTime), Break: \(breakTime)")
                    self.VC1.listViewModel.addItem(focusTime: focusTime, breakTime: breakTime, date: Date())
                    print("Items after adding: \(self.listViewModel.items.count)")
                } else {
                    self.VC1.segmentedController.selectedSegmentIndex = 1
                    self.viewModel.setBreakMode(true)
                    self.VC1.segmentedControlValueChanged()
                    let breakTime = Int(self.breakTimePicker.countDownDuration)
                    self.viewModel.startTimer(totalTime: breakTime)
                }
            }
        }
        
        VC1.listViewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.VC1.listTableView.reloadData()
                self?.VC1.updateListImageVisibility()
            }
        }
    }
}



