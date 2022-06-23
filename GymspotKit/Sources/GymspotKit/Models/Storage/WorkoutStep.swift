//
//  WorkoutStep.swift
//  
//
//  Created by Alessio Moiso on 15.05.22.
//

import Foundation

public struct WorkoutStep: Codable, Hashable {
  public enum Kind: Codable {
    case  exercise,
          rest
  }
  
  public enum Result: Codable {
    case  undefined,
          performed,
          skipped
  }
  
  public enum TimerState: Codable {
    case  none,
          running,
          paused
  }
  
  public var index: Int
  public let kind: Kind
  
  public var result = Result.undefined
  
  public var exercise: Exercise?
  public var exerciseDefinitionIndex: Int?
  public var setIndex: Int?
  
  public var values = [ExerciseValue]()
  
  public var timerState = TimerState.none
  public var timerStartedAt: Date?
  public var timerTargetDate: Date?
  public var timerLastRecordedElapsedTime: TimeInterval?
  
  public init(
    index: Int,
    kind: Kind,
    exercise: Exercise? = nil,
    exerciseDefinitionIndex: Int? = nil,
    setIndex: Int? = nil,
    values: [ExerciseValue] = []
  ) {
    self.index = index
    self.kind = kind
    
    self.exercise = exercise
    self.setIndex = setIndex
    self.exerciseDefinitionIndex = exerciseDefinitionIndex
    
    self.values = values
  }
}

extension WorkoutStep: Identifiable {
  public var id: Int { index }
}

public extension WorkoutStep {
  var isTimeBased: Bool {
    kind == .rest
  }
}
