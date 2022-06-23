//
//  WorkoutsRepositoryType.swift
//  
//
//  Created by Alessio Moiso on 17.05.22.
//

import Foundation
import Combine

public protocol WorkoutsRepositoryType {
  var all: AnyPublisher<[Workout], Error> { get }
  
  func workout(withId id: String) -> AnyPublisher<Workout?, Error>
  
  func add(workout: Workout) throws
  
  func update(workout: Workout) throws
  
  func delete(workoutWithId id: String) throws
}
