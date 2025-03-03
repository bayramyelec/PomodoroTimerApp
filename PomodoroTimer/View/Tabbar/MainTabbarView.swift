//
//  MainTabbarController.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 26.02.2025.
//

protocol CustomTabBarDelegate: AnyObject {
    func didSelectTabBarItem(at index: Int)
}

protocol ShowPlusButtonDelegate: AnyObject {
    func showPlusButtonAnimate()
}

import UIKit

class MainTabbarView: UIView {
    
    weak var delegate: CustomTabBarDelegate?
    weak var plusButtonDelegate: ShowPlusButtonDelegate?
    
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
    
    private lazy var listButton: UIButton = {
        let button = createButton(imageName: "list.bullet.rectangle.fill", tag: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var isShowPlusButton: Bool = false
    private var selectedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: screenWidth * 0.8, height: 60)
    }
    
    private func setup(){
        backgroundColor = .clear
        addSubview(tabbarView)
        tabbarView.addSubview(stackView)
        [homeButton, listButton].forEach {stackView.addArrangedSubview($0) }
        addSubview(plusButton)
        
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
        showPlusButtonAnimate()
    }
    
    private func plusButtonAnimation() {
        isShowPlusButton.toggle()
        if isShowPlusButton {
            UIView.animate(withDuration: 0.3) {
                self.plusButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.plusButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.plusButton.transform = .identity
                self.plusButton.setImage(UIImage(systemName: "hourglass"), for: .normal)
                self.layoutIfNeeded()
            }
        }
    }
}

extension MainTabbarView: ShowPlusButtonDelegate {
    func showPlusButtonAnimate() {
        plusButtonDelegate?.showPlusButtonAnimate()
    }
}
