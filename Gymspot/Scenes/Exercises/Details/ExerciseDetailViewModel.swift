//
//  ExerciseDetailViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import Foundation
import Resolver
import Combine
import GymspotKit

extension ExerciseDetailView {
  final class ExerciseDetailViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var exercisesRepository: ExercisesRepositoryType
    
    // MARK: - Published State
    @Published var exercise: Exercise?
    
    // MARK: - Actions
    func load(exercise id: String) {
      exercisesRepository.exercise(withId: id)
        .replaceError(with: nil)
        .assign(to: &$exercise)
    }
    
    func delete(exercise id: String) throws {
      try exercisesRepository.delete(exerciseWithId: id)
    }
  }
}
