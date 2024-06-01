//
//  BackgroundTimer.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/24.
//

import Foundation

protocol BackgroundTimer {
    func start(durationSeconds: Double,
               repeatingExecution: (() -> Void)?,
               completion: (() -> Void)?)
}

final class DefaultBackgroundTimer: BackgroundTimer {
    
    private var repeatingExecution: (() -> Void)?
    private var completion: (() -> Void)?
    private var timers: (repeatTimer: DispatchSourceTimer?, nonRepeatTimer: DispatchSourceTimer?) = (DispatchSource.makeTimerSource(),
                                                                                                     DispatchSource.makeTimerSource())
    
    deinit {
        removeTimer()
    }
    
    func start(durationSeconds: Double,
               repeatingExecution: (() -> Void)? = nil,
               completion: (() -> Void)? = nil) {
        setTimer(durationSeconds: durationSeconds,
                 repeatingExecution: repeatingExecution,
                 completion: completion)
        
        timers.repeatTimer?.resume()
        timers.nonRepeatTimer?.resume()
    }
    
    func cancel() {
        initTimer()
    }
    
    private func setTimer(durationSeconds: Double,
                          repeatingExecution: (() -> Void)? = nil,
                          completion: (() -> Void)? = nil) {
        initTimer()
        
        self.repeatingExecution = repeatingExecution
        self.completion = completion
        
        timers.repeatTimer?.schedule(deadline: .now(), repeating: 1)
        timers.repeatTimer?.setEventHandler(handler: repeatingExecution)
        
        timers.nonRepeatTimer?.schedule(deadline: .now() + durationSeconds)
        timers.nonRepeatTimer?.setEventHandler { [weak self] in
            self?.initTimer()
            completion?()
        }
    }
    
    private func initTimer() {
        timers.repeatTimer?.setEventHandler(handler: nil)
        timers.nonRepeatTimer?.setEventHandler(handler: nil)

        repeatingExecution = nil
        completion = nil
    }
    
    private func removeTimer() {
        timers.repeatTimer?.resume()
        timers.nonRepeatTimer?.resume()
        timers.repeatTimer?.cancel()
        timers.nonRepeatTimer?.cancel()
        initTimer()
    }
}
