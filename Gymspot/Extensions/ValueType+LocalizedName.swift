//
//  ValueType+LocalizedName.swift
//  Gymspot
//
//  Created by Alessio Moiso on 05.06.22.
//

import Foundation
import SwiftUI
import GymspotKit

extension ValueType {
  var localizedName: String {
    switch self {
    case .positiveWeight, .negativeWeight:
      return "Weight"
    case .reps:
      return "Reps"
    case .time:
      return "Time"
    }
  }
}
