//
//  MockWorkoutRoutinesRepository.swift
//  
//
//  Created by Alessio Moiso on 12.06.22.
//

import Foundation
import Combine

#if DEBUG
final class MockWorkoutRoutinesRepository: ArrayMockRepository<WorkoutRoutine>, WorkoutRoutinesRepositoryType {
  init() {
    super.init(dataSource: WorkoutRoutine.mockData)
  }
  
  func workoutRoutine(withId id: String) -> AnyPublisher<WorkoutRoutine?, Error> {
    object(withId: id)
  }
  
  func add(workoutRoutine: WorkoutRoutine) throws {
    add(object: workoutRoutine)
  }
  
  func update(workoutRoutine: WorkoutRoutine) throws {
    update(object: workoutRoutine)
  }
  
  func delete(workoutRoutineWithId id: String) throws {
    delete(objectWithId: id)
  }
}

extension WorkoutRoutine: EditableIdentifiable { }
#endif
