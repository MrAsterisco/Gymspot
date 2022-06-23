//
//  File.swift
//  
//
//  Created by Alessio Moiso on 08.05.22.
//

import Foundation

final class FirebasePathBuilder {
  private static let separator = "/"
  
  func path(for userId: String, to collection: FirebaseCollection) -> String {
    switch collection {
    case .users:
      return collection.rawValue
    default:
      return [FirebaseCollection.users.rawValue, userId, collection.rawValue].joined(separator: Self.separator)
    }
  }
}
