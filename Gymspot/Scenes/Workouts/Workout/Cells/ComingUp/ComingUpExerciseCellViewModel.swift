//
//  ComingUpExerciseCellViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 05.06.22.
//

import Foundation
import Resolver
import SwiftUI
import GymspotKit

extension ComingUpExerciseCell {
  final class ComingUpExerciseViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var valueFormatter: ExerciseValueFormatterType
    
    // MARK: - Published State
    @Published var icon: Image?
    @Published var title = ""
    @Published var subtitle = ""
    
    // MARK: - Actions
    func receive(step: WorkoutStep) {
      icon = icon(for: step)
      title = title(for: step)
      subtitle = subtitle(for: step)
    }
  }
}

// MARK: - Business Logic
private extension ComingUpExerciseCell.ComingUpExerciseViewModel {
  func icon(for step: WorkoutStep) -> Image {
    switch step.kind {
    case .exercise:
      return Image(systemName: "figure.walk")
    case .rest:
      return Image(systemName: "timer")
    }
  }
  
  func title(for step: WorkoutStep) -> String {
    switch step.kind {
    case .exercise:
      return step.exercise?.name ?? ""
    case .rest:
      return "Rest"
    }
  }
  
  func subtitle(for step: WorkoutStep) -> String {
    valueFormatter.string(forValues: step.values) ?? ""
  }
}
