//
//  File.swift
//  
//
//  Created by Alessio Moiso on 12.06.22.
//

import Foundation
import Combine

#if DEBUG
final class MockExercisesRepository: ArrayMockRepository<Exercise>, ExercisesRepositoryType {
  init() {
    super.init(dataSource: Exercise.mockData)
  }
  
  func exercise(withId id: String) -> AnyPublisher<Exercise?, Error> {
    object(withId: id)
  }
  
  func add(exercise: Exercise) throws {
    add(object: exercise)
  }
  
  func update(exercise: Exercise) throws {
    update(object: exercise)
  }
  
  func delete(exerciseWithId id: String) throws {
    delete(objectWithId: id)
  }
}

extension Exercise: EditableIdentifiable { }
#endif
