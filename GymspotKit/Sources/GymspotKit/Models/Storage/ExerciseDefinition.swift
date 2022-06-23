//
//  ExerciseDefinition.swift
//  
//
//  Created by Alessio Moiso on 12.05.22.
//

import Foundation

public struct ExerciseDefinition: Codable, Hashable {
  public var index: Int?
  public var exerciseId: String
  public var restTime: Int
  public var sets: [ExerciseSetDefinition]
  
  public init(index: Int? = nil, exerciseId: String, restTime: Int, sets: [ExerciseSetDefinition]) {
    self.index = index
    self.exerciseId = exerciseId
    self.restTime = restTime
    self.sets = sets
  }
}

extension ExerciseDefinition: Identifiable {
  public var id: Int { index ?? 0 }
}
