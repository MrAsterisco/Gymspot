//
//  WorkoutsHistorySectionViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 29.05.22.
//

import Foundation
import Resolver
import GymspotKit

extension WorkoutsHistoryView {
  final class WorkoutsHistoryViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var workoutsManager: WorkoutsManagerType
    
    // MARK: - Published State
    @Published var workouts = [Workout]()
    
    // MARK: - Initializer
    override init() {
      super.init()
      observeData()
    }
  }
}

// MARK: - Business Logic
private extension WorkoutsHistoryView.WorkoutsHistoryViewModel {
  func observeData() {
    workoutsManager.historyWorkouts
      .replaceError(with: [])
      .map { $0.sorted { $0.createdAt > $1.createdAt } }
      .assign(to: &$workouts)
  }
}
