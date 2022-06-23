//
//  File.swift
//  
//
//  Created by Alessio Moiso on 08.05.22.
//

import FirebaseAuth
import Combine
#if canImport(UIKit)
import UIKit
import AuthenticationServices
#endif

enum AuthenticationError: Error {
  case invalidIdToken
}

final class AuthenticationManager: AuthenticationManagerType {
  private let auth = Auth.auth()
  @Published private var user: UserProfile?
  
  var currentUserId: String? {
    Auth.auth().currentUser?.uid
  }
  
  var currentUser: Published<UserProfile?>.Publisher {
    $user
  }
  
  var userIdPublisher: AnyPublisher<String, Never> {
    currentUser
      .filter { $0 != nil }
      .map { $0!.id }
      .removeDuplicates()
      .eraseToAnyPublisher()
  }
  
  init() {
    update(from: Auth.auth().currentUser)
    Auth.auth().addStateDidChangeListener { [weak self] _, newUser in
      self?.update(from: newUser)
    }
  }
  
  func continueWithApple(credential: ASAuthorizationAppleIDCredential, nonce: String) async throws {
    guard
      let tokenData = credential.identityToken,
      let idToken = String(data: tokenData, encoding: .utf8)
    else {
      throw AuthenticationError.invalidIdToken
    }
    
    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
    try await auth.signIn(with: credential)
  }
}

private extension AuthenticationManager {
  func update(from user: FirebaseAuth.User?) {
    if let user = user {
      self.user = UserProfile(id: user.uid)
    } else {
      self.user = nil
    }
  }
}
