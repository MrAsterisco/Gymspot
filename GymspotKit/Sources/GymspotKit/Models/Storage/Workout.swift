//
//  Workout.swift
//  
//
//  Created by Alessio Moiso on 17.05.22.
//

import Foundation
import FirebaseFirestoreSwift

public struct Workout: Codable, Hashable {
  public enum State: Codable {
    case  ready,
          running,
          resting,
          paused,
          interrupted,
          completed
  }
  
  @DocumentID public var id: String?
  public var routineId: String
  public var name: String
  public var state = State.ready
  
  public var createdAt = Date()
  public var startedAt: Date?
  public var stoppedAt: Date?
  public var lastRecordedElapsedTime: TimeInterval = 0
  
  public var plan: [WorkoutStep]
  public var currentStepIndex: Int?
  
  public init(
    id: String? = nil,
    routineId: String,
    name: String,
    state: State = .ready,
    plan: [WorkoutStep]
  ) {
    self.id = id
    self.routineId = routineId
    self.name = name
    self.state = state
    self.plan = plan
  }
}

extension Workout: Identifiable { }
