//
//  RoutineExerciseCellViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 06.06.22.
//

import Foundation
import Resolver
import GymspotKit

extension RoutineExerciseCell {
  struct RepresentedExerciseValue: Hashable {
    let type: ValueType
    let representedValue: String
  }
  
  final class RoutineExerciseCellViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var valueFormatter: ValueFormatterType
    
    // MARK: - Published State
    @Published var title = ""
    @Published var index = 0
    @Published var setName = ""
    @Published var values = [RepresentedExerciseValue]()
    
    // MARK: - Actions
    func receive(step: WorkoutStep) {
      title = step.exercise?.name ?? ""
      index = step.index
      setName = "SET \(step.index + 1)"
      values = step.values.map {
        .init(
          type: $0.type,
          representedValue: valueFormatter.string(forValue: $0.value, ofType: $0.type) ?? ""
        )
      }
    }
  }
}
