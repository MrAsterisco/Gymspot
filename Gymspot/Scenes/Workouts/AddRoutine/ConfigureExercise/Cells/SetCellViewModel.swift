//
//  SetCellViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 12.05.22.
//

import Foundation
import Combine
import GymspotKit

extension SetCell {
  struct DraftExerciseValue: Identifiable, Equatable, Hashable {
    let id = UUID()
    let type: ValueType
    var draftValue: String
  }
  
  final class SetCellViewModel: ViewModel {
    // MARK: - Identification
    let id = UUID()
    
    // MARK: - Published State
    @Published var index = 0
    @Published var values = [SetCell.DraftExerciseValue]()
    @Published var isValid = false
    
    // MARK: - Initializer
    init(index: Int = 0, values: [ExerciseValue] = []) {
      let numberFormatter = NumberFormatter()
      
      self.index = index
      self.values = values.map {
        .init(
          type: $0.type,
          draftValue: numberFormatter.string(from: NSNumber(value: $0.value)) ?? ""
        )
      }
    }
    
    convenience init(exerciseSet: ExerciseSetDefinition) {
      self.init(
        index: exerciseSet.index,
        values: exerciseSet.values
      )
    }
    
    // MARK: - Actions
    func createSet() -> ExerciseSetDefinition {
      let numberFormatter = NumberFormatter()
      
      return .init(
        index: index,
        name: nil, // TODO: add support for set names
        values: values.map {
          .init(
            type: $0.type,
            value: numberFormatter.number(from: $0.draftValue)?.doubleValue ?? 0
          )
        }
      )
    }
  }
}

extension SetCell.SetCellViewModel: Identifiable { }
