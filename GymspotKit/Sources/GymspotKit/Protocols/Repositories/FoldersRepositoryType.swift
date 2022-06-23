//
//  FoldersRepositoryType.swift
//  
//
//  Created by Alessio Moiso on 11.06.22.
//

import Foundation
import Combine

public protocol FoldersRepositoryType {
  var all: AnyPublisher<[Folder], Error> { get }
  
  func folder(withId id: String) -> AnyPublisher<Folder?, Error>
  
  func add(folder: Folder) throws
  
  func update(folder: Folder) throws
  
  func delete(folderWithId id: String) throws
}
