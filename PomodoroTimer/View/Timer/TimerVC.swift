//
//  MainVC.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 22.02.2025.
//

import UIKit

class TimerVC: UIViewController {
    
    var viewModel: TimerViewModel
    var listViewModel: ListViewModel
    var listTableView: ListTableView!
    
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
    
    private let listImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    var isShowStopButton: Bool = false
    
    init(viewModel: TimerViewModel, listViewModel: ListViewModel) {
        self.viewModel = viewModel
        self.listViewModel = listViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.onTimerUpdate = { [weak self] totalTime in
            print("Timer updated: \(totalTime) seconds remaining")
            if self?.segmentedController.selectedSegmentIndex == 0 {
                self?.focusTimerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
            } else if self?.segmentedController.selectedSegmentIndex == 1 {
                self?.breakTimerLabel.text = String(format: "%02d:%02d:%02d", totalTime / 3600, (totalTime % 3600) / 60, totalTime % 60)
            }
        }
        
        viewModel.onTimerFinish = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if self.viewModel.timerModel.isBreak {
                    self.segmentedController.selectedSegmentIndex = 0
                    self.viewModel.setBreakMode(false)
                    self.segmentedControlValueChanged()
                    
                    let focusTime = Int(self.focusTimePicker.countDownDuration)
                    let breakTime = Int(self.breakTimePicker.countDownDuration)
                    print("Adding item - Focus: \(focusTime), Break: \(breakTime)")
                    self.listViewModel.addItem(focusTime: focusTime, breakTime: breakTime, date: Date())
                    print("Items after adding: \(self.listViewModel.items.count)")
                } else {
                    self.segmentedController.selectedSegmentIndex = 1
                    self.viewModel.setBreakMode(true)
                    self.segmentedControlValueChanged()
                    let breakTime = Int(self.breakTimePicker.countDownDuration)
                    self.viewModel.startTimer(totalTime: breakTime)
                }
            }
        }
        
        listViewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
                self?.updateListImageVisibility()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateListImageVisibility()
    }
    
    func setupUI() {
        
        listTableView = ListTableView(frame: .zero, style: .plain, viewModel: listViewModel)
        
        view.backgroundColor = UIColor.back
        view.addSubview(segmentedController)
        view.addSubview(headerBackView)
        headerBackView.addSubview(focusTimerLabel)
        headerBackView.addSubview(breakTimerLabel)
        view.addSubview(timerButtonStackView)
        [resetButton, startButton].forEach { timerButtonStackView.addArrangedSubview($0) }
        view.addSubview(listImage)
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
            
            listImage.topAnchor.constraint(equalTo: timerButtonStackView.bottomAnchor, constant: 20),
            listImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            listImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            listImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            listTableView.topAnchor.constraint(equalTo: timerButtonStackView.bottomAnchor, constant: 20),
            listTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            listTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    func updateListImageVisibility() {
        listImage.isHidden = !listViewModel.items.isEmpty
    }
    
    @objc func startButtonTapped() {
        isShowStopButton.toggle()
        print("Start button tapped, isShowStopButton: \(isShowStopButton)")
        
        if segmentedController.selectedSegmentIndex == 0 {
            viewModel.setBreakMode(false)
            if isShowStopButton {
                startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                let selectedTime = Int(focusTimePicker.countDownDuration)
                print("Starting Focus timer with \(selectedTime) seconds")
                viewModel.startTimer(totalTime: selectedTime)
            } else {
                startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                print("Stopping Focus timer")
                viewModel.stopTimer()
            }
        } else if segmentedController.selectedSegmentIndex == 1 {
            viewModel.setBreakMode(true)
            if isShowStopButton {
                startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                let selectedTime = Int(breakTimePicker.countDownDuration)
                print("Starting Break timer with \(selectedTime) seconds")
                viewModel.startTimer(totalTime: selectedTime)
            } else {
                startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                print("Stopping Break timer")
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
    
    @objc func segmentedControlValueChanged() {
        if segmentedController.selectedSegmentIndex == 0 {
            focusTimerLabel.alpha = 1
            breakTimerLabel.alpha = 0
            viewModel.setBreakMode(false)
            viewModel.resetTimer(time: Int(focusTimePicker.countDownDuration))
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isShowStopButton = false
            startButton.isEnabled = true
            resetButton.isEnabled = true
        } else if segmentedController.selectedSegmentIndex == 1 {
            focusTimerLabel.alpha = 0
            breakTimerLabel.alpha = 1
            viewModel.setBreakMode(true)
            viewModel.resetTimer(time: Int(breakTimePicker.countDownDuration))
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isShowStopButton = false
            startButton.isEnabled = false
            resetButton.isEnabled = false
        }
    }
}
