//
//  Exercise.swift
//  
//
//  Created by Alessio Moiso on 08.05.22.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Exercise: Codable, Hashable {
  @DocumentID public var id: String?
  public let name: String
  public let valueTypes: [ValueType]
  public let notes: String
  
  public init(id: String? = nil, name: String, valueTypes: [ValueType], notes: String) {
    self.id = id
    self.name = name
    self.valueTypes = valueTypes
    self.notes = notes
  }
}

extension Exercise: Identifiable { }
