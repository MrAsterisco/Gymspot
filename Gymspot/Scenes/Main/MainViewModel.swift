//
//  MainViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import Foundation
import Resolver
import Combine
import GymspotKit

extension MainView {
  final class MainViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var authenticationManager: AuthenticationManagerType
    @Injected private var stepsTimerManager: StepsTimerManagerType
    
    // MARK: - Published State
    @Published var isLoggedIn = false
    
    // MARK: - Initializer
    override init() {
      super.init()
      observeCurrentUser()
    }
    
    // MARK: - Actions
    func beginObservingTimers() {
      stepsTimerManager.beginObserving()
    }
  }
}

// MARK: - Business Logic
private extension MainView.MainViewModel {
  func observeCurrentUser() {
    authenticationManager.currentUser
      .map { $0 != nil }
      .assign(to: &$isLoggedIn)
  }
}
