//
//  ValueFormatterType.swift
//  
//
//  Created by Alessio Moiso on 06.06.22.
//

import Foundation

public protocol ValueFormatterType {
  func string(forValue value: Double, ofType type: ValueType) -> String?
  
  func positionalTimeString(forValue value: Double) -> String?
  
  func string(forValues values: [ExerciseValue]) -> String?
}
