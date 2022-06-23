//
//  WorkoutRoutine.swift
//  
//
//  Created by Alessio Moiso on 13.05.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct WorkoutRoutine: Codable, Hashable {
  @DocumentID public var id: String?
  public var name: String
  public var exercises: [ExerciseDefinition]
  public var folderId: String?
  
  public init(id: String? = nil, name: String, exercises: [ExerciseDefinition], folderId: String? = nil) {
    self.id = id
    self.name = name
    self.exercises = exercises
    self.folderId = folderId
  }
}

extension WorkoutRoutine: Identifiable { }
