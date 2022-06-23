//
//  WorkoutViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 15.05.22.
//

import Foundation
import Resolver
import GymspotKit

extension WorkoutPlanView {
  final class WorkoutPlanViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var workoutRoutinesRepository: WorkoutRoutinesRepositoryType
    @Injected private var workoutGenerator: WorkoutGeneratorType
    @Injected private var workoutsManager: WorkoutsManagerType
    
    // MARK: - Published State
    @Published var workoutRoutine: WorkoutRoutine?
    @Published var steps = [WorkoutStep]()
    
    // MARK: - Internal State
    private var workoutRoutineId: String?
    
    // MARK: - Actions
    func receive(workoutRoutineId: String) {
      self.workoutRoutineId = workoutRoutineId
      generateStepsFor(workoutRoutineId: workoutRoutineId)
    }
    
    func createWorkout(completionHandler: ((String) -> ())?) {
      guard let workoutRoutineId = workoutRoutineId else { return }
      
      Task {
        do {
          try await workoutsManager.createWorkout(from: workoutRoutineId)
          await MainActor.run {
            completionHandler?(workoutRoutineId)
          }
        } catch {
          print("Error \(error)")
        }
      }
    }
    
    func deleteWorkoutRoutine() {
      guard let workoutRoutineId = workoutRoutineId else { return }
      
      do {
        try workoutRoutinesRepository.delete(workoutRoutineWithId: workoutRoutineId)
      } catch {
        print("Error \(error)")
      }
    }
  }
}

private extension WorkoutPlanView.WorkoutPlanViewModel {
  func generateStepsFor(workoutRoutineId: String) {
    Task {
      do {
        guard
          let workoutRoutine = try await workoutRoutinesRepository.workoutRoutine(withId: workoutRoutineId).firstValue()
        else { return }
        
        let steps = try await workoutGenerator.generateTimeline(for: workoutRoutine)
        
        await MainActor.run { [weak self] in
          self?.workoutRoutine = workoutRoutine
          self?.steps = steps
        }
      } catch {
        print("Error: \(error)")
      }
    }
  }
}
