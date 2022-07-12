//
//  File.swift
//  
//
//  Created by Alessio Moiso on 02.07.22.
//

import Foundation

public protocol PredefinedValuesProviderType {
  func predefinedValues(for valueType: ValueType) -> [Double]
}
