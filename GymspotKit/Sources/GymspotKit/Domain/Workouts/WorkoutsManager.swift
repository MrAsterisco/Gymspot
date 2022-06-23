//
//  WorkoutsManager.swift
//  
//
//  Created by Alessio Moiso on 17.05.22.
//

import Foundation
import Combine

final class WorkoutsManager: WorkoutsManagerType {
  private let workoutRoutinesRepository: WorkoutRoutinesRepositoryType
  private let workoutsRepository: WorkoutsRepositoryType
  private let workoutGenerator: WorkoutGeneratorType
  
  init(
    workoutRoutinesRepository: WorkoutRoutinesRepositoryType,
    workoutsRepository: WorkoutsRepositoryType,
    workoutGenerator: WorkoutGeneratorType
  ) {
    self.workoutRoutinesRepository = workoutRoutinesRepository
    self.workoutsRepository = workoutsRepository
    self.workoutGenerator = workoutGenerator
  }
  
  var allWorkouts: AnyPublisher<[Workout], Error> {
    workoutsRepository.all
  }
  
  var activeWorkouts: AnyPublisher<[Workout], Error> {
    allWorkouts
      .map { $0.filter { $0.isActive } }
      .eraseToAnyPublisher()
  }
  
  var historyWorkouts: AnyPublisher<[Workout], Error> {
    allWorkouts
      .map { $0.filter { !$0.isActive } }
      .eraseToAnyPublisher()
  }
  
  func workout(withId id: String) -> AnyPublisher<Workout?, Error> {
    workoutsRepository.workout(withId: id)
  }
  
  func createWorkout(from workoutRoutineId: String) async throws {
    guard
      let workoutRoutine = try await workoutRoutinesRepository.workoutRoutine(withId: workoutRoutineId).firstValue()
    else {
      throw WorkoutsManagerError.workoutRoutineNotFound
    }
    
    try workoutsRepository.add(
      workout: try await workoutGenerator.generateWorkout(from: workoutRoutine)
    )
  }
  
  func start(workout id: String) async throws {
    try await performAction(onWorkout: id) { workout in
      if workout.state == .paused {
        workout.resume()
      } else {
        workout.start()
      }
    }
  }
  
  func pause(workout id: String) async throws {
    try await performAction(onWorkout: id) { workout in
      workout.pause()
    }
  }
  
  func stop(workout id: String) async throws {
    try await performAction(onWorkout: id) { workout in
      if workout.currentStepIndex == workout.plan.count - 1 {
        workout.complete()
      } else {
        workout.interrupt()
      }
    }
  }
  
  func restart(workout id: String) async throws {
    try await performAction(onWorkout: id) { workout in
      workout.reset()
    }
  }
  
  func hitAction(_ action: WorkoutAction, onWorkout id: String) async throws {
    try await performAction(onWorkout: id) { workout in
      switch action {
      case .next:
        workout.increaseStep(currentResult: .performed)
      case .skip:
        workout.increaseStep(currentResult: .skipped)
      }
    }
  }
  
  func incrementTimeForCurrentStep(ofWorkout id: String, by value: TimeInterval) async throws {
    try await performAction(onWorkout: id) { workout in
      workout.incrementTimeForCurrentStep(by: value)
    }
  }
  
  func updateValue(type: ValueType, ofCurrentStepInWorkout id: String, to value: Double, updateRoutine: Bool) async throws {
    var workoutRoutineId: String?
    var exerciseDefinitionIndex: Int?
    var setIndex: Int?
    
    try await performAction(onWorkout: id) { workout in
      guard
        let currentStepIndex = workout.currentStepIndex,
        let indexOfValueType = workout.plan[currentStepIndex].values.firstIndex(where: { $0.type == type })
      else { return }
      
      workout.plan[currentStepIndex].values[indexOfValueType].value = value
      
      workoutRoutineId = workout.routineId
      exerciseDefinitionIndex = workout.plan[currentStepIndex].exerciseDefinitionIndex
      setIndex = workout.plan[currentStepIndex].setIndex
    }
    
    guard
      updateRoutine,
      let workoutRoutineId = workoutRoutineId,
      let exerciseDefinitionIndex = exerciseDefinitionIndex,
      let setIndex = setIndex,
      var workoutRoutine = try await workoutRoutinesRepository.workoutRoutine(withId: workoutRoutineId).firstValue(),
      let indexOfValueType = workoutRoutine.exercises[exerciseDefinitionIndex].sets[setIndex].values.firstIndex(where: { $0.type == type })
    else { return }
    
    workoutRoutine.exercises[exerciseDefinitionIndex].sets[setIndex].values[indexOfValueType].value = value
    try workoutRoutinesRepository.update(workoutRoutine: workoutRoutine)
  }
}

private extension WorkoutsManager {
  func performAction(onWorkout id: String, _ action: (inout Workout) -> ()) async throws {
    guard
      var workout = try await workoutsRepository.workout(withId: id).firstValue()
    else {
      throw WorkoutsManagerError.workoutNotFound
    }
    
    action(&workout)
    
    try workoutsRepository.update(workout: workout)
  }
}

public extension Workout {
  var currentElapsedTime: TimeInterval {
    guard let startDate = startedAt else { return 0 }
    if state == .running {
      return Date().timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate + lastRecordedElapsedTime
    }
    return lastRecordedElapsedTime
  }
  
  var isAtLastStep: Bool {
    currentStepIndex == plan.count - 1
  }
}

private extension Workout {
  var isActive: Bool {
    state != .interrupted &&
    state != .completed
  }
  
  mutating func start() {
    state = .running
    startedAt = Date()
    
    if currentStepIndex == nil {
      currentStepIndex = 0
    }
  }
  
  mutating func pause() {
    lastRecordedElapsedTime = currentElapsedTime
    state = .paused
    
    guard let currentStepIndex = currentStepIndex, plan[currentStepIndex].isTimeBased else { return }
    plan[currentStepIndex].pauseTimer()
  }
  
  mutating func resume() {
    state = .running
    startedAt = Date()
    
    guard let currentStepIndex = currentStepIndex, plan[currentStepIndex].isTimeBased else { return }
    plan[currentStepIndex].startTimer()
  }
  
  mutating func interrupt() {
    lastRecordedElapsedTime = currentElapsedTime
    state = .interrupted
    stoppedAt = Date()
    
    guard let currentStepIndex = currentStepIndex, plan[currentStepIndex].isTimeBased else { return }
    plan[currentStepIndex].stopTimer()
  }
  
  mutating func complete() {
    if let currentStepIndex = currentStepIndex, plan[currentStepIndex].isTimeBased {
      plan[currentStepIndex].stopTimer()
    }
    
    lastRecordedElapsedTime = currentElapsedTime
    state = .completed
    stoppedAt = Date()
    currentStepIndex = nil
  }
  
  mutating func reset() {
    if let currentStepIndex = currentStepIndex, plan[currentStepIndex].isTimeBased {
      plan[currentStepIndex].stopTimer()
    }
    
    state = .ready
    startedAt = nil
    stoppedAt = nil
    lastRecordedElapsedTime = 0
    currentStepIndex = nil
  }
  
  mutating func increaseStep(currentResult result: WorkoutStep.Result) {
    if let currentStepIndex = currentStepIndex {
      plan[currentStepIndex].result = result
      
      if plan[currentStepIndex].isTimeBased {
        plan[currentStepIndex].stopTimer()
      }
    }
    
    guard !isAtLastStep else {
      complete()
      return
    }
    self.currentStepIndex = (self.currentStepIndex ?? 0) + 1
    
    guard let currentStepIndex = currentStepIndex, plan[currentStepIndex].isTimeBased else { return }
    plan[currentStepIndex].startTimer()
  }
  
  mutating func incrementTimeForCurrentStep(by value: TimeInterval) {
    guard let currentStepIndex = currentStepIndex else { return }
    plan[currentStepIndex].incrementTimer(by: value)
  }
}

public extension WorkoutStep {
  var currentTimerElapsedTime: TimeInterval {
    guard let timerTargetDate = timerTargetDate else { return 0 }
    
    if timerState == .running {
      return timerTargetDate.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate
    }
    return timerLastRecordedElapsedTime ?? 0
  }
  
  var currentTimerProgress: Double {
    guard
      let startDate = timerStartedAt,
      let targetDate = timerTargetDate
    else { return 0 }
    
    return currentTimerElapsedTime / (targetDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate)
  }
}

private extension WorkoutStep {
  mutating func startTimer() {
    let startDate = Date()
    
    guard
      let time = values.first(where: { $0.type == .time })?.value,
      let targetDate = Calendar.current.date(byAdding: .second, value: Int(time), to: startDate)
    else { return }
    
    timerStartedAt = startDate
    if timerState == .paused {
      timerTargetDate = targetDate - ((targetDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate) - (timerLastRecordedElapsedTime ?? 0))
    } else {
      timerTargetDate = targetDate
    }
    timerLastRecordedElapsedTime = 0
    timerState = .running
  }
  
  mutating func pauseTimer() {
    timerLastRecordedElapsedTime = currentTimerElapsedTime
    timerState = .paused
  }
  
  mutating func stopTimer() {
    if
      let startDate = timerStartedAt,
      let targetDate = timerTargetDate
    {
      timerLastRecordedElapsedTime = (targetDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate)
    }

    timerState = .none
    timerStartedAt = nil
    timerTargetDate = nil
  }
  
  mutating func incrementTimer(by value: TimeInterval) {
    guard let timerTargetDate = timerTargetDate else { return }
    self.timerTargetDate = timerTargetDate + value
  }
}
