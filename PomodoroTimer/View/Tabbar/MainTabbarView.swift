//
//  MainTabbarController.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 26.02.2025.
//

protocol CustomTabBarDelegate: AnyObject {
    func didSelectTabBarItem(at index: Int)
}

import UIKit

class MainTabbarView: UIView {
    
    weak var delegate: CustomTabBarDelegate?
    
    private let tabbarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "house.fill"), for: .normal)
        button.tintColor = .white
        button.tag = 0
        button.addTarget(self, action: #selector(createButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "hourglass", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var focusButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "timer", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.backgroundColor = .black.withAlphaComponent(0.2)
        button.layer.cornerRadius = 35
        button.alpha = 0
        button.addTarget(self, action: #selector(focusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var focusBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 35
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var breakButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "cup.and.saucer.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.backgroundColor = .black.withAlphaComponent(0.2)
        button.alpha = 0
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(breakButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var breakBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 35
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var listButton: UIButton = {
        let button = createButton(imageName: "list.bullet.rectangle.fill", tag: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isShowPlusButton: Bool = false
    private var selectedIndex: Int = 0
    
    private var isShowFocusButton: Bool = false
    private var isShowBreakButton: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: screenWidth * 0.8, height: 150)
    }
    
    private func setup(){
        backgroundColor = .clear
        addSubview(tabbarView)
        tabbarView.addSubview(stackView)
        [homeButton, listButton].forEach {stackView.addArrangedSubview($0) }
        addSubview(plusButton)
        addSubview(focusButton)
        addSubview(breakButton)
        
        addSubview(focusBackView)
        addSubview(breakBackView)
        
        NSLayoutConstraint.activate([
            tabbarView.heightAnchor.constraint(equalToConstant: 60),
            tabbarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabbarView.leftAnchor.constraint(equalTo: leftAnchor),
            tabbarView.rightAnchor.constraint(equalTo: rightAnchor),
            
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            plusButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            plusButton.widthAnchor.constraint(equalToConstant: 60),
            plusButton.heightAnchor.constraint(equalToConstant: 60),
            
            focusButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            focusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            focusButton.widthAnchor.constraint(equalToConstant: 70),
            focusButton.heightAnchor.constraint(equalToConstant: 70),
            
            breakButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            breakButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            breakButton.widthAnchor.constraint(equalToConstant: 70),
            breakButton.heightAnchor.constraint(equalToConstant: 70),
            
            focusBackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            focusBackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            focusBackView.widthAnchor.constraint(equalToConstant: 70),
            focusBackView.heightAnchor.constraint(equalToConstant: 70),
            
            breakBackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            breakBackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            breakBackView.widthAnchor.constraint(equalToConstant: 70),
            breakBackView.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func createButton(imageName: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .gray
        button.tag = tag
        button.addTarget(self, action: #selector(createButtonAction), for: .touchUpInside)
        return button
    }
    
    @objc func createButtonAction(_ sender: UIButton){
        updateSelection(selectedButton: sender)
        selectedIndex = sender.tag
        delegate?.didSelectTabBarItem(at: selectedIndex)
    }
    
    private func updateSelection(selectedButton: UIButton) {
        [homeButton, listButton].forEach { button in
            button.tintColor = button == selectedButton ? .white : .gray
        }
    }
    
    @objc func plusButtonTapped(){
        plusButtonAnimation()
    }
    
    @objc func focusButtonTapped(){
        isShowFocusButton.toggle()
        if isShowFocusButton {
            self.focusBackView.alpha = 1
            self.focusBackView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).concatenating(CGAffineTransform(translationX: 0, y: 100))
            self.layoutIfNeeded()
        } else {
            self.focusBackView.alpha = 0
            self.focusBackView.transform = .identity
            self.layoutIfNeeded()
        }
    }
    
    @objc func breakButtonTapped(){
        isShowBreakButton.toggle()
        if isShowBreakButton {
            
        } else {
            
        }
    }
    
    private func plusButtonAnimation() {
        isShowPlusButton.toggle()
        if isShowPlusButton {
            UIView.animate(withDuration: 0.3) {
                self.plusButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.plusButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                self.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                    self.focusButton.transform = CGAffineTransform(translationX: -50, y: -60)
                    self.focusButton.alpha = 1
                    self.focusBackView.transform = CGAffineTransform(translationX: -50, y: -60)
                    self.focusBackView.alpha = 0
                    self.layoutIfNeeded()
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                    self.breakButton.transform = CGAffineTransform(translationX: 50, y: -60)
                    self.breakButton.alpha = 1
                    self.breakBackView.transform = CGAffineTransform(translationX: 50, y: -60)
                    self.breakBackView.alpha = 0
                    self.layoutIfNeeded()
                })
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.plusButton.transform = .identity
                self.plusButton.setImage(UIImage(systemName: "hourglass"), for: .normal)
                self.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {                    self.breakButton.transform = .identity
                    self.breakButton.alpha = 0
                    self.breakBackView.transform = .identity
                    self.layoutIfNeeded()
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {                    self.focusButton.transform = .identity
                    self.focusButton.alpha = 0
                    self.focusBackView.transform = .identity
                    self.layoutIfNeeded()
                })
            }
        }
    }
}

