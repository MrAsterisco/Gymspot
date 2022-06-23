//
//  ExercisesTabViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import Foundation
import Resolver
import Combine
import GymspotKit

extension ExercisesListView {
  enum Mode {
    case  showcase,
          picker(String?)
  }
  
  final class ExercisesListViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var exercisesRepository: ExercisesRepositoryType
    
    // MARK: - Published State
    @Published var exercises = [Exercise]()
    
    // MARK: - Initializer
    override init() {
      super.init()
      observeData()
    }
  }
}

private extension ExercisesListView.ExercisesListViewModel {
  func observeData() {
    exercisesRepository.all
      .replaceError(with: [])
      .assign(to: &$exercises)
  }
}
