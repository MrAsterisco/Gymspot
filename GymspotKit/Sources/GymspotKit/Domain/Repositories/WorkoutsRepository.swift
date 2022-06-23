//
//  WorkoutsRepository.swift
//  
//
//  Created by Alessio Moiso on 17.05.22.
//

import Foundation
import Combine
import CombineExt

final class WorkoutsRepository: FirebaseUserRepository<Workout>, WorkoutsRepositoryType {
  private static let collection = FirebaseCollection.workouts
  
  lazy var all: AnyPublisher<[Workout], Error> = {
    all(in: Self.collection)
      .share(replay: 1)
      .eraseToAnyPublisher()
  }()
  
  func workout(withId id: String) -> AnyPublisher<Workout?, Error> {
    object(withId: id, in: Self.collection)
  }
  
  func add(workout: Workout) throws {
    try add(object: workout, to: Self.collection)
  }
  
  func update(workout: Workout) throws {
    try update(object: workout, in: Self.collection)
  }
  
  func delete(workoutWithId id: String) throws {
    try delete(objectWithId: id, from: Self.collection)
  }
}
