//
//  PredefinedValuesProvider.swift
//  
//
//  Created by Alessio Moiso on 02.07.22.
//

import Foundation

final class PredefinedValuesProvider: PredefinedValuesProviderType {
  public func predefinedValues(for valueType: ValueType) -> [Double] {
    switch valueType {
    case .positiveWeight, .negativeWeight:
      return valuesForWeight
    case .reps:
      return valuesForReps
    case .time:
      return valuesForTime
    }
  }
}

private extension PredefinedValuesProvider {
  var valuesForWeight: [Double] {
    Array(stride(from: 1, to: 250, by: 0.5))
  }
  
  var valuesForReps: [Double] {
    Array(1...50)
      .map { Double($0) }
  }
  
  var valuesForTime: [Double] {
    [
      30,
      60,
      90,
      120,
      150,
      180
    ]
  }
}
