//
//  timerButton.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 22.02.2025.
//

import UIKit

extension UIButton {
    func timerButton(imageName: String ,foregroundColor: UIColor, backgroundColor: UIColor) {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: imageName)
        config.imagePadding = 10
        config.baseForegroundColor = foregroundColor
        
        self.configuration = config
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
}
