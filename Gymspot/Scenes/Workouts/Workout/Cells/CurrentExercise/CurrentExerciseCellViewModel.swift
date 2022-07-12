//
//  CurrentExerciseCellViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 05.06.22.
//

import Foundation
import Resolver
import GymspotKit

extension CurrentExerciseCell {
  struct RepresentedExerciseValue: Hashable {
    let type: ValueType
    let representedValue: String
  }
  
  final class CurrentExerciseCellViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var valueFormatter: ExerciseValueFormatterType
    
    // MARK: - Published State
    @Published var title = ""
    @Published var setName = ""
    @Published var values = [RepresentedExerciseValue]()
    
    // MARK: - Actions
    func receive(step: WorkoutStep) {
      title = step.exercise?.name ?? ""
      setName = "SET \((step.setIndex ?? 0) + 1)"
      values = step.values.map {
        .init(
          type: $0.type,
          representedValue: valueFormatter.string(forValue: $0.value, ofType: $0.type) ?? ""
        )
      }
    }
  }
}
