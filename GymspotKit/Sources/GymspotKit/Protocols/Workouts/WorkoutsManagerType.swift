//
//  WorkoutsManagerType.swift
//  
//
//  Created by Alessio Moiso on 17.05.22.
//

import Foundation
import Combine

public enum WorkoutsManagerError: Error {
  case  workoutRoutineNotFound,
        workoutNotFound
}

public enum WorkoutAction {
  case  next,
        skip
}

public protocol WorkoutsManagerType {
  var allWorkouts: AnyPublisher<[Workout], Error> { get }
  
  var activeWorkouts: AnyPublisher<[Workout], Error> { get }
  
  var historyWorkouts: AnyPublisher<[Workout], Error> { get }
  
  func workout(withId id: String) -> AnyPublisher<Workout?, Error>
  
  func createWorkout(from workoutRoutineId: String) async throws
  
  func start(workout id: String) async throws
  
  func pause(workout id: String) async throws
  
  func stop(workout id: String) async throws
  
  func restart(workout id: String) async throws
  
  func hitAction(_ action: WorkoutAction, onWorkout id: String) async throws
  
  func incrementTimeForCurrentStep(ofWorkout id: String, by value: TimeInterval) async throws
  
  func updateValue(type: ValueType, ofCurrentStepInWorkout id: String, to value: Double, updateRoutine: Bool) async throws
}
