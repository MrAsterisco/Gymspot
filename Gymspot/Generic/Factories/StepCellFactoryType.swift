//
//  StepCellFactoryType.swift
//  Gymspot
//
//  Created by Alessio Moiso on 04.06.22.
//

import Foundation
import SwiftUI
import GymspotKit

protocol StepCellFactoryType {
  func cellFor(currentStep: WorkoutStep, inWorkout workoutId: String, editCallback: @escaping (ValueType) -> ()) -> AnyView
  
  func cellFor(nextUpStep: WorkoutStep, inWorkout workoutId: String) -> AnyView
}
