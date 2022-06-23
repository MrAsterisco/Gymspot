//
//  ValueType.swift
//  
//
//  Created by Alessio Moiso on 04.06.22.
//

import Foundation

public enum ValueType: Hashable, Codable, Comparable {
  case  positiveWeight,
        negativeWeight,
        reps,
        time
  
  var priority: Int {
    switch self {
    case .time:
      return 0
    case .positiveWeight, .negativeWeight:
      return 1
    case .reps:
      return 2
    }
  }
}

extension ValueType {
  public static func < (lhs: ValueType, rhs: ValueType) -> Bool {
    lhs.priority < rhs.priority
  }
}

public struct ExerciseValue: Hashable, Codable {
  public let type: ValueType
  public var value: Double
  
  public init(type: ValueType, value: Double) {
    self.type = type
    self.value = value
  }
}
