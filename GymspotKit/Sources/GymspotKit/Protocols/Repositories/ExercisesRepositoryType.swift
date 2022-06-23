//
//  ExercisesRepositoryType.swift
//  
//
//  Created by Alessio Moiso on 15.05.22.
//

import Foundation
import Combine

public protocol ExercisesRepositoryType {
  var all: AnyPublisher<[Exercise], Error> { get }
  
  func exercise(withId id: String) -> AnyPublisher<Exercise?, Error>
  
  func add(exercise: Exercise) throws
  
  func update(exercise: Exercise) throws
  
  func delete(exerciseWithId id: String) throws
}
