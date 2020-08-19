//
//  PrefsViewController.swift
//  time-me
//
//  Created by Aryan Barghi on 8/9/20.
//  Copyright © 2020 Aryan Barghi. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {
    
    @IBOutlet weak var customSlider: NSSlider!
    @IBOutlet weak var customTextField: NSTextField!
    
    var prefs = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        showExistingPrefs()
    }

     @IBAction func sliderValueChanged(_ sender: NSSlider) {
       showSliderValueAsText()
     }

     @IBAction func cancelButtonClicked(_ sender: Any) {
       view.window?.close()
     }

     @IBAction func okButtonClicked(_ sender: Any) {
       saveNewPrefs()
       view.window?.close()
     }
    
    func showExistingPrefs() {
      let selectedTimeInMinutes = Int(prefs.selectedTime) / 60

      customSlider.isEnabled = true

      customSlider.integerValue = selectedTimeInMinutes
      showSliderValueAsText()
    }

    func showSliderValueAsText() {
      let newTimerDuration = customSlider.integerValue
      let minutesDescription = (newTimerDuration == 1) ? "minute" : "minutes"
      customTextField.stringValue = "\(newTimerDuration) \(minutesDescription)"
    }
    
    func saveNewPrefs() {
       prefs.selectedTime = customSlider.doubleValue * 60
       NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"),
                                       object: nil)
     }
    
}
