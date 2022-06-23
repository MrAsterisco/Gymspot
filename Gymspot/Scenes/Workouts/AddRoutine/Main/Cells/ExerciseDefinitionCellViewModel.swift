//
//  ExerciseDefinitionCellViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 15.05.22.
//

import Foundation
import Resolver
import GymspotKit

extension ExerciseDefinitionCell {
  final class ExerciseDefinitionCellViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var exercisesRepository: ExercisesRepositoryType
    
    // MARK: - Published State
    @Published var exerciseName = ""
    @Published var definition: ExerciseDefinition
    
    // MARK: - Initializer
    init(definition: ExerciseDefinition) {
      self.definition = definition
      super.init()
      retrieveExercise(withId: definition.exerciseId)
    }
  }
}

private extension ExerciseDefinitionCell.ExerciseDefinitionCellViewModel {
  func retrieveExercise(withId id: String) {
    Task {
      guard
        let exercise = try? await exercisesRepository.exercise(withId: id).firstValue()
      else { return }
      
      await MainActor.run { [weak self] in
        self?.exerciseName = exercise.name
      }
    }
  }
}
