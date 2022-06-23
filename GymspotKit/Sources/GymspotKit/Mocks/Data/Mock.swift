//
//  Mock.swift
//  
//
//  Created by Alessio Moiso on 12.06.22.
//

import Foundation

#if DEBUG
extension Exercise {
  static var mockData: [Exercise] = [
    .init(id: "0", name: "Pushups", valueTypes: [.reps], notes: "Some notes"),
    .init(id: "1", name: "Squats", valueTypes: [.reps, .positiveWeight], notes: "Add more weight"),
    .init(id: "2", name: "Dumbbell Rows", valueTypes: [.reps, .positiveWeight], notes: "Chest must be open"),
    .init(id: "3", name: "Machine Assisted Chin Up", valueTypes: [.reps, .negativeWeight], notes: ""),
    .init(id: "4", name: "Leg Extension", valueTypes: [.reps, .positiveWeight], notes: ""),
    .init(id: "5", name: "Lying Leg Curl", valueTypes: [.reps, .positiveWeight], notes: ""),
    .init(id: "6", name: "Knee Raise (Captain's Chair)", valueTypes: [.reps, .positiveWeight], notes: ""),
    .init(id: "7", name: "Lat Pulldown (Cable)", valueTypes: [.reps, .positiveWeight], notes: "Double weight for certain machines"),
    .init(id: "8", name: "Shoulder Press", valueTypes: [.reps, .positiveWeight], notes: "")
  ]
}


extension Folder {
  static var mockData: [Folder] = [
    .init(id: "0", name: "Current"),
    .init(id: "1", name: "Past")
  ]
}

extension WorkoutRoutine {
  static var mockData: [WorkoutRoutine] = [
    .init(
      id: "0",
      name: "Core",
      exercises: [
        .init(
          index: 0,
          exerciseId: "0",
          restTime: 90,
          sets: [
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 10)]),
            .init(index: 1, name: nil, values: [.init(type: .reps, value: 10)])
          ]
        ),
        .init(
          index: 1,
          exerciseId: "6",
          restTime: 90,
          sets: [
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15)]),
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15)]),
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15)])
          ]
        )
      ],
      folderId: "0"
    ),
    .init(
      id: "1",
      name: "Legs",
      exercises: [
        .init(
          index: 0,
          exerciseId: "4",
          restTime: 90,
          sets: [
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15), .init(type: .positiveWeight, value: 32)]),
            .init(index: 1, name: nil, values: [.init(type: .reps, value: 15), .init(type: .positiveWeight, value: 36)])
          ]
        ),
        .init(
          index: 1,
          exerciseId: "5",
          restTime: 90,
          sets: [
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15), .init(type: .positiveWeight, value: 12)]),
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15), .init(type: .positiveWeight, value: 12)]),
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15), .init(type: .positiveWeight, value: 16)])
          ]
        )
      ],
      folderId: "0"
    ),
    .init(
      id: "2",
      name: "Shoulders",
      exercises: [
        .init(
          index: 0,
          exerciseId: "8",
          restTime: 90,
          sets: [
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15), .init(type: .positiveWeight, value: 12)]),
            .init(index: 1, name: nil, values: [.init(type: .reps, value: 15), .init(type: .positiveWeight, value: 12)])
          ]
        )
      ],
      folderId: "1"
    ),
    .init(
      id: "3",
      name: "Back",
      exercises: [
        .init(
          index: 0,
          exerciseId: "2",
          restTime: 90,
          sets: [
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15), .init(type: .positiveWeight, value: 12)]),
            .init(index: 1, name: nil, values: [.init(type: .reps, value: 15), .init(type: .positiveWeight, value: 12)])
          ]
        ),
        .init(
          index: 0,
          exerciseId: "3",
          restTime: 90,
          sets: [
            .init(index: 0, name: nil, values: [.init(type: .reps, value: 15), .init(type: .negativeWeight, value: 40)]),
            .init(index: 1, name: nil, values: [.init(type: .reps, value: 15), .init(type: .negativeWeight, value: 40)])
          ]
        )
      ],
      folderId: nil
    )
  ]
}

extension Workout {
  static var mockData: [Workout] = [
    .init(
      id: "0",
      routineId: "1",
      name: "Legs",
      state: .running,
      plan: [
        .init(
          index: 0,
          kind: .exercise,
          exercise: .init(id: "4", name: "Leg Extension", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 0,
          setIndex: 0,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 32)
          ]
        ),
        .init(
          index: 1,
          kind: .rest,
          exercise: nil,
          exerciseDefinitionIndex: nil,
          setIndex: nil,
          values: [.init(type: .time, value: 90)]
        ),
        .init(
          index: 2,
          kind: .exercise,
          exercise: .init(id: "4", name: "Leg Extension", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 0,
          setIndex: 1,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 36)
          ]
        ),
        .init(
          index: 3,
          kind: .rest,
          exercise: nil,
          exerciseDefinitionIndex: nil,
          setIndex: nil,
          values: [.init(type: .time, value: 90)]
        ),
        .init(
          index: 4,
          kind: .exercise,
          exercise: .init(id: "5", name: "Lying Leg Curl", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 1,
          setIndex: 0,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 12)
          ]
        ),
        .init(
          index: 5,
          kind: .rest,
          exercise: nil,
          exerciseDefinitionIndex: nil,
          setIndex: nil,
          values: [.init(type: .time, value: 90)]
        ),
        .init(
          index: 6,
          kind: .exercise,
          exercise: .init(id: "5", name: "Lying Leg Curl", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 1,
          setIndex: 1,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 12)
          ]
        ),
        .init(
          index: 7,
          kind: .rest,
          exercise: nil,
          exerciseDefinitionIndex: nil,
          setIndex: nil,
          values: [.init(type: .time, value: 90)]
        ),
        .init(
          index: 8,
          kind: .exercise,
          exercise: .init(id: "5", name: "Lying Leg Curl", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 1,
          setIndex: 2,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 16)
          ]
        )
      ]
    ),
    .init(
      id: "1",
      routineId: "1",
      name: "Legs",
      state: .completed,
      plan: [
        .init(
          index: 0,
          kind: .exercise,
          exercise: .init(id: "4", name: "Leg Extension", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 0,
          setIndex: 0,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 32)
          ]
        ),
        .init(
          index: 1,
          kind: .rest,
          exercise: nil,
          exerciseDefinitionIndex: nil,
          setIndex: nil,
          values: [.init(type: .time, value: 90)]
        ),
        .init(
          index: 2,
          kind: .exercise,
          exercise: .init(id: "4", name: "Leg Extension", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 0,
          setIndex: 1,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 36)
          ]
        ),
        .init(
          index: 3,
          kind: .rest,
          exercise: nil,
          exerciseDefinitionIndex: nil,
          setIndex: nil,
          values: [.init(type: .time, value: 90)]
        ),
        .init(
          index: 4,
          kind: .exercise,
          exercise: .init(id: "5", name: "Lying Leg Curl", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 1,
          setIndex: 0,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 12)
          ]
        ),
        .init(
          index: 5,
          kind: .rest,
          exercise: nil,
          exerciseDefinitionIndex: nil,
          setIndex: nil,
          values: [.init(type: .time, value: 90)]
        ),
        .init(
          index: 6,
          kind: .exercise,
          exercise: .init(id: "5", name: "Lying Leg Curl", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 1,
          setIndex: 1,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 12)
          ]
        ),
        .init(
          index: 7,
          kind: .rest,
          exercise: nil,
          exerciseDefinitionIndex: nil,
          setIndex: nil,
          values: [.init(type: .time, value: 90)]
        ),
        .init(
          index: 8,
          kind: .exercise,
          exercise: .init(id: "5", name: "Lying Leg Curl", valueTypes: [.reps, .positiveWeight], notes: ""),
          exerciseDefinitionIndex: 1,
          setIndex: 2,
          values: [
            .init(type: .reps, value: 15),
            .init(type: .positiveWeight, value: 16)
          ]
        )
      ]
    )
  ]
}
#endif
