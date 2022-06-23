//
//  ValueFormatter.swift
//  
//
//  Created by Alessio Moiso on 06.06.22.
//

import Foundation

final class ValueFormatter: ValueFormatterType {
  // MARK: - Formatters
  private lazy var measurementFormatter = MeasurementFormatter()
  
  private lazy var integerNumberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 0
    return formatter
  }()
  
  private lazy var positionalTimeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.includesApproximationPhrase = false
    formatter.includesTimeRemainingPhrase = false
    formatter.collapsesLargestUnit = false
    formatter.unitsStyle = .positional
    formatter.allowsFractionalUnits = true
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = [.pad]
    return formatter
  }()
  
  private lazy var briefTimeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.includesApproximationPhrase = false
    formatter.includesTimeRemainingPhrase = false
    formatter.collapsesLargestUnit = true
    formatter.unitsStyle = .brief
    formatter.allowsFractionalUnits = false
    formatter.allowedUnits = [.second]
    return formatter
  }()
  
  // MARK: - Initializer
  init() { }
  
  // MARK: - Protocol Implementation
  func string(forValue value: Double, ofType type: ValueType) -> String? {
    switch type {
    case .positiveWeight, .negativeWeight:
      return stringForWeight(value, isAdding: type != .negativeWeight)
    case .reps:
      return stringForReps(value)
    case .time:
      return stringForTime(value)
    }
  }
  
  func positionalTimeString(forValue value: Double) -> String? {
    positionalTimeFormatter.string(from: value)
  }
  
  func string(forValues values: [ExerciseValue]) -> String? {
    values
      .sorted(by: { $0.type < $1.type })
      .compactMap { [weak self] exerciseValue in
        self?.string(forValue: exerciseValue.value, ofType: exerciseValue.type)
      }
      .joined(separator: " ")
  }
}

// MARK: - Business Logic
private extension ValueFormatter {
  func stringForWeight(_ value: Double, isAdding: Bool) -> String? {
    measurementFormatter.string(from: .init(value: isAdding ? value : -value, unit: UnitMass.kilograms))
  }
  
  func stringForReps(_ value: Double) -> String? {
    "x\((integerNumberFormatter.string(from: NSNumber(value: value)) ?? "0"))"
  }
  
  func stringForTime(_ value: Double) -> String? {
    briefTimeFormatter.string(from: value)
  }
}
