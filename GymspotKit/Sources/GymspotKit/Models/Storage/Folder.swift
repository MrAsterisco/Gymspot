//
//  File.swift
//  
//
//  Created by Alessio Moiso on 11.06.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Folder: Codable, Hashable {
  @DocumentID public var id: String?
  public var name: String
  
  public init(id: String? = nil, name: String) {
    self.id = id
    self.name = name
  }
}

extension Folder: Identifiable { }
