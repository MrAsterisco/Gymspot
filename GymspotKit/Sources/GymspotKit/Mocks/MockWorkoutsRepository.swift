//
//  File.swift
//  
//
//  Created by Alessio Moiso on 12.06.22.
//

import Foundation
import Combine

#if DEBUG
final class MockWorkoutsRepository: ArrayMockRepository<Workout>, WorkoutsRepositoryType {
  init() {
    super.init(dataSource: Workout.mockData)
  }
  
  func workout(withId id: String) -> AnyPublisher<Workout?, Error> {
    object(withId: id)
  }
  
  func add(workout: Workout) throws {
    add(object: workout)
  }
  
  func update(workout: Workout) throws {
    update(object: workout)
  }
  
  func delete(workoutWithId id: String) throws {
    delete(objectWithId: id)
  }
}

extension Workout: EditableIdentifiable { }
#endif
