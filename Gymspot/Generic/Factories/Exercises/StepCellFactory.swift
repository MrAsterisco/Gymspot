//
//  StepCellFactory.swift
//  Gymspot
//
//  Created by Alessio Moiso on 04.06.22.
//

import Foundation
import SwiftUI
import GymspotKit

final class StepCellFactory: StepCellFactoryType {
  func cellFor(currentStep: WorkoutStep, inWorkout workoutId: String, editCallback: @escaping (ValueType) -> ()) -> AnyView {
    switch currentStep.kind {
    case .exercise:
      return AnyView(
        CurrentExerciseCell(
          workoutStep: currentStep,
          editCallback: editCallback
        )
      )
    case .rest:
      return AnyView(
        CurrentRestCell(
          workoutId: workoutId,
          stepIndex: currentStep.index
        )
      )
    }
  }
  
  func cellFor(nextUpStep: WorkoutStep, inWorkout workoutId: String) -> AnyView {
    AnyView(
      ComingUpExerciseCell(workoutStep: nextUpStep)
    )
  }
}
