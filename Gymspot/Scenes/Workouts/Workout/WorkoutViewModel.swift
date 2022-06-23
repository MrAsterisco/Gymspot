//
//  WorkoutViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 28.05.22.
//

import Foundation
import Resolver
import Combine
import SwiftUI
import GymspotKit

extension WorkoutView {
  enum ExerciseInteraction {
    case  none,
          skipAndNext,
          time,
          finish
  }
  
  final class WorkoutViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var workoutsManager: WorkoutsManagerType
    @Injected private var stepCellFactory: StepCellFactoryType
    @Injected private var valueFormatter: ValueFormatterType
    
    // MARK: - Published State
    @Published var workout: Workout?
    
    @Published var currentStep: WorkoutStep?
    @Published var nextSteps = [WorkoutStep]()
    
    @Published var currentTime = ""
    
    @Published var canStop = true
    @Published var canPause = true
    @Published var canPlay = true
    @Published var canRestart = false
    
    @Published var exerciseInteraction = ExerciseInteraction.none
    
    @Published var editedValueType: ValueType?
    @Published var editedValue = ""
    @Published var editingUpdatesRoutine = true
    
    // MARK: - Internal State
    private var workoutId: String?
    
    // MARK: - Initializer
    override init() {
      super.init()
      
      observeWorkout()
      observeTime()
      observeCurrentStep()
      observeNextSteps()
      observeExerciseInteraction()
    }
    
    // MARK: - Actions
    func load(workout id: String) {
      self.workoutId = id
      workoutsManager.workout(withId: id)
        .replaceError(with: nil)
        .assign(to: &$workout)
    }
    
    func playWorkout() {
      guard let workoutId = workoutId else { return }
      
      Task {
        try await workoutsManager.start(workout: workoutId)
      }
    }
    
    func pauseWorkout() {
      guard let workoutId = workoutId else { return }
      
      Task {
        try await workoutsManager.pause(workout: workoutId)
      }
    }
    
    func stopWorkout() {
      guard let workoutId = workoutId else { return }
      
      Task {
        try await workoutsManager.stop(workout: workoutId)
      }
    }
    
    func restartWorkout() {
      guard let workoutId = workoutId else { return }
      
      Task {
        try await workoutsManager.restart(workout: workoutId)
      }
    }
    
    func nextStep() {
      guard let workoutId = workoutId else { return }
      
      Task {
        try await workoutsManager.hitAction(.next, onWorkout: workoutId)
      }
    }
    
    func skipStep() {
      guard let workoutId = workoutId else { return }
      
      Task {
        try await workoutsManager.hitAction(.skip, onWorkout: workoutId)
      }
    }
    
    func increaseTimer() {
      guard let workoutId = workoutId else { return }
      
      Task {
        try await workoutsManager.incrementTimeForCurrentStep(ofWorkout: workoutId, by: TimeInterval.defaultTimeIncrement)
      }
    }
    
    func decreaseTimer() {
      guard let workoutId = workoutId else { return }
      
      Task {
        try await workoutsManager.incrementTimeForCurrentStep(ofWorkout: workoutId, by: -TimeInterval.defaultTimeIncrement)
      }
    }
    
    func generateCell(forCurrentStep step: WorkoutStep, editCallback: @escaping (ValueType) -> ()) -> AnyView {
      guard let workoutId = workoutId else { return AnyView(Spacer()) }
      return stepCellFactory.cellFor(currentStep: step, inWorkout: workoutId, editCallback: editCallback)
    }
    
    func generateCell(forNextUpStep step: WorkoutStep) -> AnyView {
      guard let workoutId = workoutId else { return AnyView(Spacer()) }
      return stepCellFactory.cellFor(nextUpStep: step, inWorkout: workoutId)
    }
    
    func beginEditingCurrentStep(valueType: ValueType) {
      editedValueType = valueType
      
      $currentStep
        .filter { $0 != nil }.map { $0! }
        .map {
          String($0.values.first(where: { $0.type == valueType })?.value ?? 0)
        }
        .assign(to: &$editedValue)
    }
    
    func updateCurrentStep() {
      let numberFormatter = NumberFormatter()
      
      guard
        let editedValueType = editedValueType,
        let editedValueParsed = numberFormatter.number(from: editedValue)?.doubleValue,
        let workoutId = workoutId
      else {
        return
      }

      Task {
        try await workoutsManager.updateValue(
          type: editedValueType,
          ofCurrentStepInWorkout: workoutId,
          to: editedValueParsed,
          updateRoutine: editingUpdatesRoutine
        )
      }
    }
  }
}

// MARK: - Business Logic
private extension WorkoutView.WorkoutViewModel {
  func observeWorkout() {
    $workout
      .map { $0?.state }
      .replaceNil(with: .ready)
      .sink { [weak self] state in
        self?.canStop = state.canBeStopped
        self?.canPause = state.canBePaused
        self?.canPlay = state.canBeStarted
        self?.canRestart = state.canBeRestarted
      }
      .store(in: &cancellables)
  }
  
  func observeTime() {
    Timer.publish(every: 0.5, on: .main, in: .common)
      .autoconnect()
      .withLatestFrom($workout) { [valueFormatter] (currentDate, workout) -> String in
        guard let workout = workout else { return "" }
        return valueFormatter.positionalTimeString(forValue: workout.currentElapsedTime) ?? ""
      }
      .assign(to: &$currentTime)
  }
  
  func observeCurrentStep() {
    $workout
      .map { workout -> WorkoutStep? in
        guard
          let workout = workout
        else { return nil }
        
        return workout.plan[workout.currentStepIndex ?? 0]
      }
      .assign(to: &$currentStep)
  }
  
  func observeNextSteps() {
    $workout
      .map { workout -> [WorkoutStep] in
        guard
          let workout = workout
        else { return [] }
        
        let currentStepIndex = workout.currentStepIndex ?? 0
        return Array(workout.plan.suffix(from: currentStepIndex+1))
      }
      .assign(to: &$nextSteps)
  }
  
  func observeExerciseInteraction() {
    $workout
      .filter { $0 != nil }.map { $0! }
      .map { $0.interaction }
      .assign(to: &$exerciseInteraction)
  }
}

private extension TimeInterval {
  static var defaultTimeIncrement: TimeInterval {
    15
  }
}

private extension Workout.State {
  var canBeStopped: Bool {
    self == .running || self == .paused
  }
  
  var canBePaused: Bool {
    self == .running
  }
  
  var canBeStarted: Bool {
    self == .ready || self == .paused
  }
  
  var canBeRestarted: Bool {
    self == .interrupted || self == .paused
  }
}

private extension Workout {
  var interaction: WorkoutView.ExerciseInteraction {
    guard
      state.canBePaused,
      let currentStepIndex = currentStepIndex
    else { return .none }
    
    guard !isAtLastStep else { return .finish }
    
    let step = plan[currentStepIndex]
    switch step.kind {
    case .exercise:
      return .skipAndNext
    case .rest:
      return .time
    }
  }
}
