//
//  ExerciseSetDefinition.swift
//  
//
//  Created by Alessio Moiso on 12.05.22.
//

import Foundation

public struct ExerciseSetDefinition: Codable, Hashable {
  public var index: Int
  public var name: String?
  public var values: [ExerciseValue]
  
  public init(index: Int, name: String?, values: [ExerciseValue]) {
    self.index = index
    self.name = name
    self.values = values
  }
}

extension ExerciseSetDefinition: Identifiable {
  public var id: Int { index }
}
