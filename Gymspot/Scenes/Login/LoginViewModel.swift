//
//  LoginViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import Foundation
import AuthenticationServices
import Resolver
import GymspotKit

extension LoginView {
  enum State {
    case  ready,
          loading,
          error(Error)
  }
  
  final class LoginViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var authenticationManager: AuthenticationManagerType
    
    // MARK: - Published State
    @Published var state = State.ready
    
    // MARK: - Internal State
    private var nonce: String?
    
    // MARK: - Actions
    func configureRequest(request: ASAuthorizationAppleIDRequest) {
      nonce = String.secureRandomString()
      request.nonce = nonce!.sha256
      request.requestedScopes = []
    }
    
    func continueWithApple(result: Result<ASAuthorization, Error>) {
      state = .loading
      
      switch result {
      case let .success(authorization):
        handle(authorization: authorization)
      case .failure:
        state = .ready
      }
    }
  }
}

// MARK: - Business Logic
private extension LoginView.LoginViewModel {
  func handle(authorization: ASAuthorization) {
    guard
      let nonce = nonce,
      let credential = authorization.credential as? ASAuthorizationAppleIDCredential
    else { return }

    Task {
      do {
        try await authenticationManager.continueWithApple(credential: credential, nonce: nonce)
        await updateState(to: .ready)
      } catch {
        await updateState(to: .error(error))
      }
    }
  }
  
  @MainActor private func updateState(to state: LoginView.State) {
    self.state = state
  }
}
