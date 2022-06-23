//
//  WorkoutRoutinesRepositoryType.swift
//  
//
//  Created by Alessio Moiso on 15.05.22.
//

import Foundation
import Combine

public protocol WorkoutRoutinesRepositoryType {
  var all: AnyPublisher<[WorkoutRoutine], Error> { get }
  
  func workoutRoutine(withId id: String) -> AnyPublisher<WorkoutRoutine?, Error>
  
  func add(workoutRoutine: WorkoutRoutine) throws
  
  func update(workoutRoutine: WorkoutRoutine) throws
  
  func delete(workoutRoutineWithId id: String) throws
}
