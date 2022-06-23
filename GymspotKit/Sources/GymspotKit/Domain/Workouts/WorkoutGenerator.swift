//
//  File.swift
//  
//
//  Created by Alessio Moiso on 17.05.22.
//

import Foundation
import Combine

final class WorkoutGenerator: WorkoutGeneratorType {
  private let exercisesRepository: ExercisesRepositoryType
  
  init(exercisesRepository: ExercisesRepositoryType) {
    self.exercisesRepository = exercisesRepository
  }
  
  func generateWorkout(from workoutRoutine: WorkoutRoutine) async throws -> Workout {
    .init(
      routineId: workoutRoutine.id ?? "",
      name: workoutRoutine.name ?? "",
      plan: try await generateTimeline(for: workoutRoutine)
    )
  }
  
  func generateTimeline(for workoutRoutine: WorkoutRoutine) async throws -> [WorkoutStep] {
    var steps = [WorkoutStep]()
    var overallIndex = 0
    
    for exerciseDefinition in workoutRoutine.exercises {
      steps.append(contentsOf: try await generate(for: exerciseDefinition, in: workoutRoutine.id, with: &overallIndex))
    }
    
    return steps
  }
}

private extension WorkoutGenerator {
  func generate(for exerciseDefinition: ExerciseDefinition, in workoutRoutineId: String?, with overallIndex: inout Int) async throws -> [WorkoutStep] {
    let exercise = try await exercisesRepository.exercise(withId: exerciseDefinition.exerciseId).firstValue()
    var steps = [WorkoutStep]()
    
    for setDefinition in exerciseDefinition.sets {
      steps += [
        .init(
          index: overallIndex,
          kind: .exercise,
          exercise: exercise,
          exerciseDefinitionIndex: exerciseDefinition.index,
          setIndex: setDefinition.index,
          values: setDefinition.values
        ),
        .init(
          index: overallIndex + 1,
          kind: .rest,
          exerciseDefinitionIndex: exerciseDefinition.index,
          values: [.init(type: .time, value: Double(exerciseDefinition.restTime))]
        )
      ]
      
      overallIndex += 2
    }
    
    return steps
  }
}
