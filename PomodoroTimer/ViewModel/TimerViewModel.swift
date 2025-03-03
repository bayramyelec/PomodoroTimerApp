//
//  HomeViewModel.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 27.02.2025.
//

import UIKit

class TimerViewModel {
    
    var timer: Timer?
    var timerModel = TimerModel(focustime: 60, breakTime: 60, isBreak: false, isRunning: false)
    private var focusRemainingTime: Int = 0
    private var breakRemainingTime: Int = 0
    
    var onTimerUpdate: ((Int) -> Void)?
    var onTimerFinish: (() -> Void)?
    
    func startTimer(totalTime: Int) {
        guard !timerModel.isRunning else { return }
        
        
        if timerModel.isBreak {
            if focusRemainingTime > 0 {
                timerModel.totalTime = focusRemainingTime
            } else {
                timerModel.totalTime = totalTime
            }
            
            timerModel.isRunning = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.timerModel.totalTime > 0 {
                    self.timerModel.totalTime -= 1
                    self.focusRemainingTime = self.timerModel.totalTime
                    DispatchQueue.main.async {
                        self.onTimerUpdate?(self.timerModel.totalTime)
                    }
                } else {
                    self.stopTimer()
                    self.onTimerFinish?()
                }
            }
        } else {
            if breakRemainingTime > 0 {
                timerModel.totalTime = breakRemainingTime
            } else {
                timerModel.totalTime = totalTime
            }
            
            timerModel.isRunning = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.timerModel.totalTime > 0 {
                    self.timerModel.totalTime -= 1
                    self.breakRemainingTime = self.timerModel.totalTime
                    DispatchQueue.main.async {
                        self.onTimerUpdate?(self.timerModel.totalTime)
                    }
                } else {
                    self.stopTimer()
                    self.onTimerFinish?()
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
        focusRemainingTime = 0
        breakRemainingTime = 0
        onTimerUpdate?(timerModel.totalTime)
    }
    
}
