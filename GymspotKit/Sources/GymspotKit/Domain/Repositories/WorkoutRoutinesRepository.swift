//
//  WorkoutsRepository.swift
//  
//
//  Created by Alessio Moiso on 13.05.22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import CombineExt

final class WorkoutRoutinesRepository: FirebaseUserRepository<WorkoutRoutine>, WorkoutRoutinesRepositoryType {
  private static let collection = FirebaseCollection.workoutRoutines
  
  lazy var all: AnyPublisher<[WorkoutRoutine], Error> = {
    all(in: Self.collection)
      .share(replay: 1)
      .eraseToAnyPublisher()
  }()
  
  func workoutRoutine(withId id: String) -> AnyPublisher<WorkoutRoutine?, Error> {
    object(withId: id, in: Self.collection)
  }
  
  func add(workoutRoutine: WorkoutRoutine) throws {
    try add(object: workoutRoutine, to: Self.collection)
  }
  
  func update(workoutRoutine: WorkoutRoutine) throws {
    try update(object: workoutRoutine, in: Self.collection)
  }
  
  func delete(workoutRoutineWithId id: String) throws {
    try delete(objectWithId: id, from: Self.collection)
  }
}
