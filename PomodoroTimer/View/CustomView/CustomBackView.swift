//
//  CustomBackView.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 26.02.2025.
//

import UIKit

class CustomBackView: UIView {
    
    var timer: Timer?
    var totalTime: Int = 60
    
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
        label.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor.back
        
        addSubview(headerBackView)
        headerBackView.addSubview(timerLabel)
        addSubview(timerButtonStackView)
        addSubview(startButton)
        addSubview(resetButton)
        addSubview(timePickerView)
        timePickerView.addSubview(focusTimePicker)
        [timePickerButton, startButton, resetButton].forEach { timerButtonStackView.addArrangedSubview($0)}
        
        focusTimePickerWidth = timePickerView.widthAnchor.constraint(equalToConstant: 0)
        focusTimePickerHeight = timePickerView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            headerBackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            headerBackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            headerBackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            headerBackView.heightAnchor.constraint(equalToConstant: screenWidth  * 0.5),
            
            timerLabel.centerXAnchor.constraint(equalTo: headerBackView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: headerBackView.centerYAnchor),
            
            timerButtonStackView.topAnchor.constraint(equalTo: headerBackView.bottomAnchor, constant: 30),
            timerButtonStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
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
    
}

extension CustomBackView {
    @objc func startButtonTapped() {
        isFocusTimePickerShowing = false
        timePickerShowingAnimation()
        isShowStopButton.toggle()
        
        if isShowStopButton {
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            if timer == nil {
                totalTime = Int(focusTimePicker.countDownDuration)
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector (updateTimer), userInfo: nil, repeats: true)
            } else {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector (updateTimer), userInfo: nil, repeats: true)
            }
        } else {
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer?.invalidate()
        }
    }
    
    @objc func resetButtonTapped() {
        isFocusTimePickerShowing = false
        timePickerShowingAnimation()
        timer?.invalidate()
        totalTime = Int(focusTimePicker.countDownDuration)
        timerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
        startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        timer = nil
    }
    
    @objc func updateTimer(){
        if totalTime > 0 {
            totalTime -= 1
            timerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
        } else {
            timer?.invalidate()
        }
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
                self.focusTimePickerWidth.constant = self.screenWidth * 0.5
                self.focusTimePickerHeight.constant = self.screenWidth * 0.3
                self.timePickerView.transform = CGAffineTransform(translationX: 5, y: 20)
                self.focusTimePicker.alpha = 1
                self.layoutIfNeeded()
            }
        } else {
            self.focusTimePicker.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.focusTimePickerWidth.constant = 0
                self.focusTimePickerHeight.constant = 0
                self.timePickerView.transform = .identity
                self.layoutIfNeeded()
            }
        }
    }
}
