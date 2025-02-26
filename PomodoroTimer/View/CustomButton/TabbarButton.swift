//
//  TabbarButton.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 26.02.2025.
//

import UIKit

extension UIButton {
    func TabbarButton(image: UIImage) {
        var config = UIButton.Configuration.plain()
        config.image = image
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        self.configuration = config
    }
}
