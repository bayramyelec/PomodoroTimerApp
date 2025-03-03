//
//  TimerModel.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 28.02.2025.
//

import Foundation

struct TimerModel {
    var focustime: Int
    var breakTime: Int
    var isBreak: Bool
    var totalTime: Int {
        get {
            return isBreak ? breakTime : focustime
        }
        set {
            if isBreak {
                breakTime = newValue
            } else {
                focustime = newValue
            }
        }
    }
    var isRunning: Bool
}
