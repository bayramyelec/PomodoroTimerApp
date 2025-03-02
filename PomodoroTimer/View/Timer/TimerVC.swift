//
//  MainVC.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 22.02.2025.
//

import UIKit

class TimerVC: UIViewController {
    
    var viewModel = TimerViewModel()
    
    var focusTimePicker: UIDatePicker!
    
    private lazy var segmentedController: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Focus", "Break"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = .systemYellow.withAlphaComponent(0.6)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private var headerBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.font = UIFont(name: "DS-Digital", size: screenWidth * 0.2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "%02d:%02d:%02d", viewModel.timerModel.totalTime / 3600, (viewModel.timerModel.totalTime % 3600) / 60, viewModel.timerModel.totalTime % 60)
        return label
    }()
    
    private let timerButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.timerButton(imageName: "gobackward", foregroundColor: .white, backgroundColor: .black)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var isShowStopButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        viewModel.onTimerUpdate = { [weak self] totalTime in
            self?.timerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.back
        view.addSubview(segmentedController)
        view.addSubview(headerBackView)
        headerBackView.addSubview(timerLabel)
        view.addSubview(timerButtonStackView)
        [resetButton, startButton].forEach { timerButtonStackView.addArrangedSubview($0) }
        
        
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedController.heightAnchor.constraint(equalToConstant: 30),
            segmentedController.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            
            headerBackView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 10),
            headerBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            headerBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            headerBackView.heightAnchor.constraint(equalToConstant: screenWidth  * 0.5),
            
            timerLabel.centerXAnchor.constraint(equalTo: headerBackView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: headerBackView.centerYAnchor),
            
            timerButtonStackView.topAnchor.constraint(equalTo: headerBackView.bottomAnchor, constant: 30),
            timerButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 100),
            
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    @objc func startButtonTapped() {
        isShowStopButton.toggle()
        
        if isShowStopButton {
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            let selectedTime = Int(focusTimePicker.countDownDuration)
            viewModel.startTimer(totalTime: selectedTime)
        } else {
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            viewModel.stopTimer()
        }
    }
    
    @objc func resetButtonTapped() {
        isShowStopButton = false
        viewModel.resetTimer(time: Int(focusTimePicker.countDownDuration))
        startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    @objc func segmentedControlValueChanged(){
        if segmentedController.selectedSegmentIndex == 0 {
            
        } else if segmentedController.selectedSegmentIndex == 1 {
            
        }
    }
    
}


#Preview {
    TimerVC()
}
