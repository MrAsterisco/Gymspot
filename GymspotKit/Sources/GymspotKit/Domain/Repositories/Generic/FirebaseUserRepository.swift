//
//  FirebaseUserRepository.swift
//  
//
//  Created by Alessio Moiso on 14.05.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

/// A class to access, observe and interact with a collection on Firebase Firestore that lives
/// under a specific user domain.
///
/// # Overview
/// This repository handles CRUD operations, including observation for a repository stored on
/// Firebase Firestore that is owned by a specific user. The repository is automatically created
/// under a path that follows this convention:
///
/// ```
/// /users/<userId>/<collectionName>
/// ```
///
/// Collections are defined in ``FirebaseCollection``.
///
/// # Subclassing
/// You are strongly encouraged to subclass this repository to provide direct
/// access to a specific collection. You can, for example, provide methods that do not require the
/// `collection` parameter to be specified every time.
class FirebaseUserRepository<Model: Identifiable & Codable> where Model.ID == String? {
  enum Errors: Error {
    case  invalidUser,
          invalidObject
  }
  
  private let authenticationManager: AuthenticationManagerType
  private let store = Firestore.firestore()
  private let pathBuilder = FirebasePathBuilder()
  
  required init(authenticationManager: AuthenticationManagerType) {
    self.authenticationManager = authenticationManager
  }
  
  func all(in collection: FirebaseCollection) -> AnyPublisher<[Model], Error> {
    authenticationManager.userIdPublisher
      .setFailureType(to: Error.self)
      .flatMapLatest { [store, pathBuilder] (userId: String) -> AnyPublisher<[Model], Error> in
        store.collection(pathBuilder.path(for: userId, to: collection))
          .publisher()
          .eraseToAnyPublisher()
      }
  }
  
  func object(withId id: String, in collection: FirebaseCollection) -> AnyPublisher<Model?, Error> {
    all(in: collection)
      .map { $0.first { $0.id == id } }
      .eraseToAnyPublisher()
  }
  
  func add(object: Model, to collection: FirebaseCollection) throws {
    guard
      let userId = authenticationManager.currentUserId
    else {
      throw Errors.invalidUser
    }
    
    _ = try store.collection(pathBuilder.path(for: userId, to: collection))
      .addDocument(from: object)
  }
  
  func update(object: Model, in collection: FirebaseCollection) throws {
    guard
      let userId = authenticationManager.currentUserId
    else {
      throw Errors.invalidUser
    }
    
    guard
      let objectId = object.id
    else {
      throw Errors.invalidObject
    }
    
    try store.collection(pathBuilder.path(for: userId, to: collection))
      .document(objectId)
      .setData(from: object)
  }
  
  func delete(objectWithId objectId: String, from collection: FirebaseCollection) throws {
    guard
      let userId = authenticationManager.currentUserId
    else {
      throw Errors.invalidUser
    }
    
    store.collection(pathBuilder.path(for: userId, to: collection))
      .document(objectId)
      .delete()
  }
}

private extension CollectionReference {
  func publisher<T: Codable>() -> AnyPublisher<[T], Error> {
    let subject = PassthroughSubject<[T], Error>()
    let listener = addSnapshotListener { snapshot, error in
      if let error = error {
        subject.send(completion: .failure(error))
      }
      
      subject.send(
        snapshot?.documents.compactMap { try? $0.data(as: T.self) } ?? []
      )
    }
    
    return subject
      .handleEvents(
        receiveCompletion: { _ in listener.remove() },
        receiveCancel: listener.remove
      )
      .eraseToAnyPublisher()
  }
}

private extension Publisher {
  /// Projects each element of a publisher into a new sequence of publishers
  /// and then transforms a publisher of publishers into a publisher
  /// producing values only from the most recent publisher.
  ///
  /// - note: This is a combination of `map` and `switchToLatest`.
  /// - seealso: https://forums.swift.org/t/confused-about-behaviour-of-switchtolatest-in-combine/29914
  /// - parameters:
  ///   - transform: A transform function to apply to each element.
  /// - returns: A publisher whose elements are the result of invoking the transform function on each element of source producing
  ///   a Publisher of Publishers and that at any point in time produces the elements of the most recent inner publisher that has been received.
  func flatMapLatest<T: Publisher>(_ transform: @escaping (Self.Output) -> T) -> AnyPublisher<T.Output, T.Failure> where T.Failure == Self.Failure {
    return map(transform)
      .switchToLatest()
      .eraseToAnyPublisher()
  }
}
