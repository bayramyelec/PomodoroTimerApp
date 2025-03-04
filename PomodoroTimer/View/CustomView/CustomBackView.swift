//
//  CustomBackView.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 26.02.2025.
//

import UIKit

class CustomBackView: UIView {
    
    var viewModel = TimerViewModel()
    
    var focusTimePicker: UIDatePicker!
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.backgroundColor = UIColor.back
        self.addSubview(headerBackView)
        headerBackView.addSubview(timerLabel)
        self.addSubview(timerButtonStackView)
        [resetButton, startButton].forEach { timerButtonStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            headerBackView.topAnchor.constraint(equalTo: self.topAnchor),
            headerBackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerBackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            timerLabel.centerXAnchor.constraint(equalTo: headerBackView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: headerBackView.centerYAnchor),
            
            timerButtonStackView.topAnchor.constraint(equalTo: headerBackView.bottomAnchor, constant: 30),
            timerButtonStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
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
//            viewModel.startTimer(totalTime: selectedTime, selectedIndex: segmentedController.selectedSegmentIndex)
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
    
}
