//
//  CurrentRestCellViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 03.06.22.
//

import Foundation
import Resolver
import GymspotKit

extension CurrentRestCell {
  final class CurrentRestCellViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var workoutsManager: WorkoutsManagerType
    @Injected private var valueFormatter: ExerciseValueFormatterType
    
    // MARK: - Published State
    @Published var currentStep: WorkoutStep?
    
    @Published var totalTime = ""
    @Published var currentProgress = 0.0
    @Published var currentTime = ""
    
    // MARK: - Initializer
    override init() {
      super.init()
      
      observeTime()
    }
    
    // MARK: - Actions
    func load(stepAt index: Int, inWorkout id: String) {
      workoutsManager.workout(withId: id)
        .replaceError(with: nil)
        .map { workout -> WorkoutStep? in
          guard
            let workout = workout
          else { return nil }
          
          return workout.plan[index]
        }
        .assign(to: &$currentStep)
      
      $currentStep
        .map { [valueFormatter] in
          valueFormatter.string(forValue: $0?.values.first(where: { $0.type == .time })?.value ?? 0, ofType: .time) ?? ""
        }
        .assign(to: &$totalTime)
    }
  }
}

// MARK: - Business Logic
private extension CurrentRestCell.CurrentRestCellViewModel {
  func observeTime() {
    Timer.publish(every: 0.5, on: .main, in: .common)
      .autoconnect()
      .withLatestFrom($currentStep) { (currentDate, currentStep) -> (TimeInterval, TimeInterval) in
        guard let currentStep = currentStep else { return (0, 0) }
        return (currentStep.currentTimerElapsedTime, currentStep.currentTimerProgress)
      }
      .handleEvents(receiveOutput: { [weak self] in
        self?.currentProgress = $0.1
      })
      .map { [valueFormatter] in
        valueFormatter.positionalTimeString(forValue: $0.0) ?? ""
      }
      .assign(to: &$currentTime)
  }
}
