//
//  File.swift
//  
//
//  Created by Alessio Moiso on 08.05.22.
//
import Combine
import AuthenticationServices

public protocol AuthenticationManagerType {
  var currentUserId: String? { get }
  
  var currentUser: Published<UserProfile?>.Publisher { get }
  
  var userIdPublisher: AnyPublisher<String, Never> { get }
  
  func continueWithApple(credential: ASAuthorizationAppleIDCredential, nonce: String) async throws
}
