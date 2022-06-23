//
//  File.swift
//  
//
//  Created by Alessio Moiso on 12.06.22.
//

import Foundation
import Combine

#if DEBUG
final class MockFoldersRepository: ArrayMockRepository<Folder>, FoldersRepositoryType {
  init() {
    super.init(dataSource: Folder.mockData)
  }
  
  func folder(withId id: String) -> AnyPublisher<Folder?, Error> {
    object(withId: id)
  }
  
  func add(folder: Folder) throws {
    add(object: folder)
  }
  
  func update(folder: Folder) throws {
    update(object: folder)
  }
  
  func delete(folderWithId id: String) throws {
    delete(objectWithId: id)
  }
}

extension Folder: EditableIdentifiable { }
#endif
