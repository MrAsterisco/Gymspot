//
//  WorkoutGeneratorType.swift
//  
//
//  Created by Alessio Moiso on 17.05.22.
//

import Foundation

public protocol WorkoutGeneratorType {
  func generateWorkout(from workoutRoutine: WorkoutRoutine) async throws -> Workout
  
  func generateTimeline(for workoutRoutine: WorkoutRoutine) async throws -> [WorkoutStep]
}
