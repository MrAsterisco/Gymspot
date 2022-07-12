//
//  RoutineRestCellViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.06.22.
//

import Foundation
import Resolver
import GymspotKit

extension RoutineRestCell {
  final class RoutineRestCellViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var valueFormatter: ExerciseValueFormatterType
    
    // MARK: - Published State
    @Published var restTime = ""
    
    // MARK: - Actions
    func receive(workoutStep: WorkoutStep) {
      guard
        let time = workoutStep.values.first(where: { $0.type == .time })?.value
      else { return }
      
      restTime = valueFormatter.string(forValue: time, ofType: .time) ?? ""
    }
  }
}
