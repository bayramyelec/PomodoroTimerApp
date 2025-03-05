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
    var breakTimePicker: UIDatePicker!
    
    lazy var segmentedController: UISegmentedControl = {
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
    
    lazy var focusTimerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.font = UIFont(name: "DS-Digital", size: screenWidth * 0.2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "%02d:%02d:%02d", viewModel.timerModel.totalTime / 3600, (viewModel.timerModel.totalTime % 3600) / 60, viewModel.timerModel.totalTime % 60)
        label.alpha = 1
        return label
    }()
    
    lazy var breakTimerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.font = UIFont(name: "DS-Digital", size: screenWidth * 0.2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "%02d:%02d:%02d", viewModel.timerModel.totalTime / 3600, (viewModel.timerModel.totalTime % 3600) / 60, viewModel.timerModel.totalTime % 60)
        label.alpha = 0
        return label
    }()
    
    let timerButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = false
        return stackView
    }()
    
    lazy var startButton: UIButton = {
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
    
    private lazy var listTableView = ListTableView()
    
    var isShowStopButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.onTimerUpdate = { [weak self] totalTime in
            if self?.segmentedController.selectedSegmentIndex == 0 {
                self?.focusTimerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
            } else if self?.segmentedController.selectedSegmentIndex == 1 {
                self?.breakTimerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
            }
        }
        
        viewModel.onTimerFinish = { [weak self] in
            DispatchQueue.main.async {
                self?.segmentedController.selectedSegmentIndex = 1
                self?.segmentedControlValueChanged()
                self?.viewModel.startTimer(totalTime: Int(self?.breakTimePicker.countDownDuration ?? 0))
                DispatchQueue.main.asyncAfter(deadline: .now() + (self?.breakTimePicker.countDownDuration ?? 0)) {
                    self?.viewModel.stopTimer()
                }
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.back
        view.addSubview(segmentedController)
        view.addSubview(headerBackView)
        headerBackView.addSubview(focusTimerLabel)
        headerBackView.addSubview(breakTimerLabel)
        view.addSubview(timerButtonStackView)
        [resetButton, startButton].forEach { timerButtonStackView.addArrangedSubview($0) }
        view.addSubview(listTableView)
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedController.heightAnchor.constraint(equalToConstant: 30),
            segmentedController.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            
            headerBackView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 10),
            headerBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            headerBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            headerBackView.heightAnchor.constraint(equalToConstant: screenWidth  * 0.5),
            
            focusTimerLabel.centerXAnchor.constraint(equalTo: headerBackView.centerXAnchor),
            focusTimerLabel.centerYAnchor.constraint(equalTo: headerBackView.centerYAnchor),
            
            breakTimerLabel.centerXAnchor.constraint(equalTo: headerBackView.centerXAnchor),
            breakTimerLabel.centerYAnchor.constraint(equalTo: headerBackView.centerYAnchor),
            
            timerButtonStackView.topAnchor.constraint(equalTo: headerBackView.bottomAnchor, constant: 30),
            timerButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 100),
            
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 60),
            
            listTableView.topAnchor.constraint(equalTo: timerButtonStackView.bottomAnchor, constant: 20),
            listTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            listTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
            
        ])
    }
    
    @objc func startButtonTapped() {
        isShowStopButton.toggle()
        
        if segmentedController.selectedSegmentIndex == 0 {
            if isShowStopButton {
                startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                let selectedTime = Int(focusTimePicker.countDownDuration)
                viewModel.startTimer(totalTime: selectedTime)
            } else {
                startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                viewModel.stopTimer()
            }
        } else if segmentedController.selectedSegmentIndex == 1 {
            if isShowStopButton {
                startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                let selectedTime = Int(breakTimePicker.countDownDuration)
                viewModel.startTimer(totalTime: selectedTime)
            } else {
                startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                viewModel.stopTimer()
            }
        }
    }
    
    @objc func resetButtonTapped() {
        if segmentedController.selectedSegmentIndex == 0 {
            isShowStopButton = false
            viewModel.resetTimer(time: Int(focusTimePicker.countDownDuration))
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else if segmentedController.selectedSegmentIndex == 1 {
            isShowStopButton = false
            viewModel.resetTimer(time: Int(breakTimePicker.countDownDuration))
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        
    }
    
    @objc func segmentedControlValueChanged(){
        if segmentedController.selectedSegmentIndex == 0 {
            self.focusTimerLabel.alpha = 1
            self.breakTimerLabel.alpha = 0
            self.viewModel.resetTimer(time: Int(focusTimePicker.countDownDuration))
            self.startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.isShowStopButton = false
            self.timerButtonStackView.isHidden = false
        } else if segmentedController.selectedSegmentIndex == 1 {
            self.focusTimerLabel.alpha = 0
            self.breakTimerLabel.alpha = 1
            self.viewModel.resetTimer(time: Int(breakTimePicker.countDownDuration))
            self.startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.isShowStopButton = false
            self.timerButtonStackView.isHidden = true
        }
    }
    
}
