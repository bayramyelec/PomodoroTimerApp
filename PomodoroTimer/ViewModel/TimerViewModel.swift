//
//  HomeViewModel.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 27.02.2025.
//

import UIKit

class TimerViewModel {
    
    private var timer: Timer?
    var timerModel = TimerModel(totalTime: 60, isRunning: false)
    private var remainingTime: Int = 0
    
    var onTimerUpdate: ((Int) -> Void)?
    var onTimerFinish: (() -> Void)?
    
    func startTimer(totalTime: Int) {
        guard !timerModel.isRunning else { return }
        
        if remainingTime > 0 {
            timerModel.totalTime = remainingTime
        } else {
            timerModel.totalTime = totalTime
        }
        
        timerModel.isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timerModel.totalTime > 0 {
                self.timerModel.totalTime -= 1
                self.remainingTime = self.timerModel.totalTime
                DispatchQueue.main.async {
                    self.onTimerUpdate?(self.timerModel.totalTime)
                }
            } else {
                self.stopTimer()
                self.onTimerFinish?()
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
        remainingTime = 0
        onTimerUpdate?(timerModel.totalTime)
    }
    
}
