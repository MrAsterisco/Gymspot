//
//  WorkoutRoutinesManagerType.swift
//  
//
//  Created by Alessio Moiso on 11.06.22.
//

import Foundation
import Combine

public protocol WorkoutRoutinesManagerType {
  var all: AnyPublisher<[GroupedItem], Error> { get }
  
  func workoutRoutine(withId id: String) -> AnyPublisher<WorkoutRoutine?, Error>
  
  func add(workoutRoutine: WorkoutRoutine) throws
  
  func update(workoutRoutine: WorkoutRoutine) throws
  
  func delete(workoutRoutineWithId id: String) throws
  
  func delete(folderWithId id: String) async throws
}
