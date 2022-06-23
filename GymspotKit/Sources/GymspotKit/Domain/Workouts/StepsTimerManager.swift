//
//  StepsTimerManager.swift
//  
//
//  Created by Alessio Moiso on 04.06.22.
//

import Foundation
import Combine

final class StepsTimerManager: StepsTimerManagerType {
  private let workoutsManager: WorkoutsManagerType
  private var cancellables = Set<AnyCancellable>()
  
  init(workoutsManager: WorkoutsManagerType) {
    self.workoutsManager = workoutsManager
  }
  
  func beginObserving() {
    Timer.publish(every: 0.5, on: .main, in: .common)
      .autoconnect()
      .setFailureType(to: Error.self)
      .flatMapLatest { [workoutsManager] _ in workoutsManager.activeWorkouts }
      .map { (activeWorkouts: [Workout]) -> [String] in
        activeWorkouts.compactMap { (workout: Workout) -> String? in
          guard let currentStepIndex = workout.currentStepIndex else { return nil }
          
          let currentStep = workout.plan[currentStepIndex]
          guard
            currentStep.isTimeBased,
            currentStep.timerState == .running,
            let targetDate = currentStep.timerTargetDate,
            Date() >= targetDate
          else { return nil }
          
          return workout.id
        }
      }
      .flatMap { [workoutsManager] (workoutIds: [String]) -> Future<Int, Never> in
        Future { promise in
          Task {
            for workoutId in workoutIds {
              try await workoutsManager.hitAction(.next, onWorkout: workoutId)
            }
            promise(.success(workoutIds.count))
          }
        }
      }
      .sink(receiveCompletion: { _ in }) { _ in }
      .store(in: &cancellables)
  }
}
