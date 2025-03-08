//
//  HomeViewModel.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 27.02.2025.
//

import Foundation

final class TimerViewModel {
    
    var timer: Timer?
    var timerModel = TimerModel(focustime: 60, breakTime: 60, isBreak: false, isRunning: false)
    private var focusRemainingTime: Int = 0
    private var breakRemainingTime: Int = 0
    
    var onTimerUpdate: ((Int) -> Void)?
    var onTimerFinish: (() -> Void)?
        
    func startTimer(totalTime: Int) {
        guard !timerModel.isRunning else { return }
        
        if timerModel.isBreak {
            timerModel.totalTime = breakRemainingTime > 0 ? breakRemainingTime : totalTime
        } else {
            timerModel.totalTime = focusRemainingTime > 0 ? focusRemainingTime : totalTime
        }
        
        timerModel.isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timerModel.totalTime > 0 {
                self.timerModel.totalTime -= 1
                if self.timerModel.isBreak {
                    self.breakRemainingTime = self.timerModel.totalTime
                } else {
                    self.focusRemainingTime = self.timerModel.totalTime
                }
                DispatchQueue.main.async {
                    self.onTimerUpdate?(self.timerModel.totalTime)
                }
            } else {
                self.stopTimer()
                DispatchQueue.main.async {
                    self.onTimerFinish?() // Her iki timer bittiğinde çağrılır
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timerModel.isRunning = false
    }
    
    func resetTimer(time: Int) {
        stopTimer()
        timerModel.totalTime = time
        if timerModel.isBreak {
            breakRemainingTime = time
        } else {
            focusRemainingTime = time
        }
        onTimerUpdate?(timerModel.totalTime)
    }
    
    func setBreakMode(_ isBreak: Bool) {
        timerModel.isBreak = isBreak
    }
}
