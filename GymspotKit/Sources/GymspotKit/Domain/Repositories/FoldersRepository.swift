//
//  FoldersRepository.swift
//  
//
//  Created by Alessio Moiso on 11.06.22.
//

import Foundation
import Combine

final class FoldersRepository: FirebaseUserRepository<Folder>, FoldersRepositoryType {
  private static let collection = FirebaseCollection.folders
  
  lazy var all: AnyPublisher<[Folder], Error> = {
    all(in: Self.collection)
      .share(replay: 1)
      .eraseToAnyPublisher()
  }()
  
  func folder(withId id: String) -> AnyPublisher<Folder?, Error> {
    object(withId: id, in: Self.collection)
  }
  
  func add(folder: Folder) throws {
    try add(object: folder, to: Self.collection)
  }
  
  func update(folder: Folder) throws {
    try update(object: folder, in: Self.collection)
  }
  
  func delete(folderWithId id: String) throws {
    try delete(objectWithId: id, from: Self.collection)
  }
}

