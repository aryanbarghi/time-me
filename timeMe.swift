//
//  timeMe.swift
//  time-me
//
//  Created by Aryan Barghi on 8/9/20.
//  Copyright © 2020 Aryan Barghi. All rights reserved.
//

import Foundation

protocol timeMeProtocol {
  func timeRemainingOnTimer(_ timer: timeMe, timeRemaining: TimeInterval)
  func timerHasFinished(_ timer: timeMe)
}

class timeMe {
    
    var delegate: timeMeProtocol?
    
    var timer: Timer? = nil
    var startTime: Date?
    var duration: TimeInterval = 360      // default = 6 minutes
    var elapsedTime: TimeInterval = 0
    
    var isStopped: Bool {
      return timer == nil && elapsedTime == 0
    }
    var isPaused: Bool {
      return timer == nil && elapsedTime > 0
        }

    @objc dynamic func timerAction() {
        
    // startTime initialized; if nil passed in, timer is not running, return nothing
    guard let startTime = startTime else {
    return
    }

    // change sign to positive
    elapsedTime = -startTime.timeIntervalSinceNow

    // calculate time remaining
    let secondsRemaining = (duration - elapsedTime).rounded()

    // if finished, return finished state to delegate. otherwise, return remaining time
    if secondsRemaining <= 0 {
    resetTimer()
    delegate?.timerHasFinished(self)
    } else {
    delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
      }
    }

    
    // MARK: - Start, etc. functions
    
    func startTimer() {
      startTime = Date()
      elapsedTime = 0

      timer = Timer.scheduledTimer(timeInterval: 1,
                                   target: self,
                                   selector: #selector(timerAction),
                                   userInfo: nil,
                                   repeats: true)
      timerAction()
    }

    func resumeTimer() {
      startTime = Date(timeIntervalSinceNow: -elapsedTime)

      timer = Timer.scheduledTimer(timeInterval: 1,
                                   target: self,
                                   selector: #selector(timerAction),
                                   userInfo: nil,
                                   repeats: true)
      timerAction()
    }

    func stopTimer() {
      // really just pauses the timer
      timer?.invalidate()
      timer = nil

      timerAction()
    }

    func resetTimer() {
      // stop the timer & reset back to start
      timer?.invalidate()
      timer = nil

      startTime = nil
      duration = 360
      elapsedTime = 0

      timerAction()
    }
    
}
