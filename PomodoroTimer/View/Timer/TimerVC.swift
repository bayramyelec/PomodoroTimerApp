//
//  MainVC.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 22.02.2025.
//

import UIKit

class TimerVC: UIViewController {
    
    var viewModel = TimerViewModel()
    
    private var segmentedController: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Focus", "Break"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = .systemYellow.withAlphaComponent(0.6)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
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
    
    private lazy var timerLabel: UILabel = {
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
    
    private lazy var timePickerButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.timerButton(imageName: "clock.fill", foregroundColor: .white, backgroundColor: .black)
        button.addTarget(self, action: #selector(timePickerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var timePickerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var focusTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.alpha = 0
        datePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    var focusTimePickerWidth: NSLayoutConstraint!
    var focusTimePickerHeight: NSLayoutConstraint!
    var isFocusTimePickerShowing: Bool = false
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
        view.addSubview(startButton)
        view.addSubview(resetButton)
        view.addSubview(timePickerView)
        timePickerView.addSubview(focusTimePicker)
        [timePickerButton, startButton, resetButton].forEach { timerButtonStackView.addArrangedSubview($0)}
        
        focusTimePickerWidth = timePickerView.widthAnchor.constraint(equalToConstant: 0)
        focusTimePickerHeight = timePickerView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
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
            
            timePickerButton.heightAnchor.constraint(equalToConstant: 50),
            timePickerButton.widthAnchor.constraint(equalToConstant: 60),
            
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 100),
            
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 60),
            
            focusTimePickerWidth,
            focusTimePickerHeight,
            timePickerView.topAnchor.constraint(equalTo: timePickerButton.bottomAnchor),
            timePickerView.leftAnchor.constraint(equalTo: timePickerButton.rightAnchor, constant: -25),
            
            focusTimePicker.topAnchor.constraint(equalTo: timePickerView.topAnchor),
            focusTimePicker.leadingAnchor.constraint(equalTo: timePickerView.leadingAnchor),
            focusTimePicker.trailingAnchor.constraint(equalTo: timePickerView.trailingAnchor),
            focusTimePicker.bottomAnchor.constraint(equalTo: timePickerView.bottomAnchor),
            
        ])
        
    }
    
    @objc func startButtonTapped() {
        isFocusTimePickerShowing = false
        timePickerShowingAnimation()
        isShowStopButton.toggle()
        
        if isShowStopButton {
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            viewModel.startTimer(totalTime: viewModel.timerModel.totalTime)
        } else {
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            viewModel.stopTimer()
        }
    }
    
    @objc func resetButtonTapped() {
        isFocusTimePickerShowing = false
        timePickerShowingAnimation()
        viewModel.resetTimer(time: Int(focusTimePicker.countDownDuration))
        startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    @objc func timePickerButtonTapped(){
        isFocusTimePickerShowing.toggle()
        timePickerShowingAnimation()
    }
    
    @objc func timePickerValueChanged() {
        let remainingTime = Int(focusTimePicker.countDownDuration)
        timerLabel.text = String(format: "%02d:%02d:%02d", remainingTime / 3600, (remainingTime % 3600) / 60, remainingTime % 60)
    }
    
    private func timePickerShowingAnimation() {
        if isFocusTimePickerShowing {
            UIView.animate(withDuration: 0.3) {
                self.focusTimePickerWidth.constant = self.view.frame.width * 0.5
                self.focusTimePickerHeight.constant = self.view.frame.width * 0.3
                self.timePickerView.transform = CGAffineTransform(translationX: 5, y: 20)
                self.focusTimePicker.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            self.focusTimePicker.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.focusTimePickerWidth.constant = 0
                self.focusTimePickerHeight.constant = 0
                self.timePickerView.transform = .identity
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

#Preview {
    TimerVC()
}
