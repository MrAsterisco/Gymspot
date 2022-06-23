//
//  ArrayMockRepository.swift
//  
//
//  Created by Alessio Moiso on 12.06.22.
//

import Foundation
import Combine

#if DEBUG
protocol EditableIdentifiable {
  associatedtype ID
  var id: ID { get set }
}

class ArrayMockRepository<Model: EditableIdentifiable & Hashable> where Model.ID == String? {
  @Published private var dataSource: [Model]
  
  init(dataSource: [Model]) {
    self._dataSource = .init(initialValue: dataSource)
  }
  
  var all: AnyPublisher<[Model], Error> {
    $dataSource
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  func object(withId id: String) -> AnyPublisher<Model?, Error> {
    all
      .map {
        $0.first { $0.id == id }
      }
      .eraseToAnyPublisher()
  }
  
  func add(object: Model) {
    var newObject = object
    newObject.id = UUID().uuidString
    
    dataSource.append(newObject)
  }
  
  func update(object: Model) {
    guard let index = dataSource.firstIndex(where: { $0.id == object.id }) else { return }
    dataSource[index] = object
  }
  
  func delete(objectWithId id: String) {
    dataSource.removeAll { $0.id == id }
  }
}
#endif
