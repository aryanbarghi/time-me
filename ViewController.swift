//
//  ViewController.swift
//  time-me
//
//  Created by Aryan Barghi on 8/8/20.
//  Copyright © 2020 Aryan Barghi. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var timeLeftField: NSTextField!
    
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var prefsButton: NSButton!
    
    var timeMeObj = timeMe()
    var prefs = Preferences()
    var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timeMeObj.delegate = self
        setupPrefs()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if timeMeObj.isPaused {
            timeMeObj.resumeTimer()
        } else {
            timeMeObj.duration = prefs.selectedTime
            timeMeObj.startTimer()
        }
        configureButtons()
        prepareSound()
    }

    @IBAction func stopButtonClicked(_ sender: Any) {
        timeMeObj.stopTimer()
        configureButtons()
    }

    @IBAction func resetButtonClicked(_ sender: Any) {
        timeMeObj.resetTimer()
        updateDisplay(for: prefs.selectedTime)
        configureButtons()
    }
    @IBAction func prefsButtonClicked(_ sender: Any) {
        // preferences
    }
    
}

extension ViewController: timeMeProtocol {

  func timeRemainingOnTimer(_ timer: timeMe, timeRemaining: TimeInterval) {
    updateDisplay(for: timeRemaining)
  }

  func timerHasFinished(_ timer: timeMe) {
    updateDisplay(for: 0)
    playSound()
  }
}

extension ViewController {

  // MARK: - Display

  func updateDisplay(for timeRemaining: TimeInterval) {
    timeLeftField.stringValue = textToDisplay(for: timeRemaining)
  }

  private func textToDisplay(for timeRemaining: TimeInterval) -> String {
    if timeRemaining == 0 {
      return "Done!"
    }

    let minutesRemaining = floor(timeRemaining / 60)
    let secondsRemaining = timeRemaining - (minutesRemaining * 60)

    let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
    let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"

    return timeRemainingDisplay
  }
    
    func configureButtons() {
        let enableStart: Bool
        let enableStop: Bool
        let enableReset: Bool
        let enablePrefs: Bool
        
        if timeMeObj.isStopped {
            enableStart = true
            enableStop = false
            enableReset = false
            enablePrefs = true
        
        } else if timeMeObj.isPaused {
            enableStart = true
            enableStop = false
            enableReset = true
            enablePrefs = true
        } else {
            enableStart = false
            enableStop = true
            enableReset = false
            enablePrefs = true
        }

        startButton.isEnabled = enableStart
        stopButton.isEnabled = enableStop
        resetButton.isEnabled = enableReset
        prefsButton.isEnabled = enablePrefs
    }
}

extension ViewController {

  // MARK: - Preferences

  func setupPrefs() {
    updateDisplay(for: prefs.selectedTime)

    let notificationName = Notification.Name(rawValue: "PrefsChanged")
    NotificationCenter.default.addObserver(forName: notificationName,
                                           object: nil, queue: nil) {
      (notification) in
      self.checkForResetAfterPrefsChange()
    }
  }

  func updateFromPrefs() {
    self.timeMeObj.duration = self.prefs.selectedTime
    self.resetButtonClicked(self)
  }
    
    // prompt user with dialogue if time is changed while running
    func checkForResetAfterPrefsChange() {
      if timeMeObj.isStopped || timeMeObj.isPaused {
        updateFromPrefs()
      } else {
        let alert = NSAlert()
        alert.messageText = "Are you sure you would like to reset the timer with your new settings?"
        alert.alertStyle = .warning

        alert.addButton(withTitle: "Reset")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()
        if response == NSApplication.ModalResponse.alertFirstButtonReturn {
          self.updateFromPrefs()
        }
      }
    }
}

extension ViewController {

  // MARK: - Sound

  func prepareSound() {
    guard let audioFileUrl = Bundle.main.url(forResource: "finish",
                                             withExtension: "m4a") else {
      return
    }

    do {
      soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
      soundPlayer?.prepareToPlay()
    } catch {
      print("Sound player not available: \(error)")
    }
  }

  func playSound() {
    soundPlayer?.play()
  }

}
