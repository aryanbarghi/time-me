//
//  Preferences.swift
//  time-me
//
//  Created by Aryan Barghi on 8/9/20.
//  Copyright © 2020 Aryan Barghi. All rights reserved.
//

import Foundation

struct Preferences {

  var selectedTime: TimeInterval {
    get {
      // if time is greater than 0 (aka updated) it is returned
      let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
      if savedTime > 0 {
        return savedTime
      }
      // else return default value of 360 sec, or 6 min
      return 360
    }
    set {
      // set new value
      UserDefaults.standard.set(newValue, forKey: "selectedTime")
    }
  }

}
