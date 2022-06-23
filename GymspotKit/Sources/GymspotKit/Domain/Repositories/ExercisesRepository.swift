//
//  File.swift
//  
//
//  Created by Alessio Moiso on 08.05.22.
//
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import CombineExt

final class ExercisesRepository: FirebaseUserRepository<Exercise>, ExercisesRepositoryType {
  private static let collection = FirebaseCollection.exercises
  
  lazy var all: AnyPublisher<[Exercise], Error> = {
    all(in: Self.collection)
      .share(replay: 1)
      .eraseToAnyPublisher()
  }()
  
  func exercise(withId id: String) -> AnyPublisher<Exercise?, Error> {
    object(withId: id, in: Self.collection)
  }
  
  func add(exercise: Exercise) throws {
    try add(object: exercise, to: Self.collection)
  }
  
  func update(exercise: Exercise) throws {
    try update(object: exercise, in: Self.collection)
  }
  
  func delete(exerciseWithId id: String) throws {
    try delete(objectWithId: id, from: Self.collection)
  }
}
