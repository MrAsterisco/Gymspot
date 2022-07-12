//
//  SetCellViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 12.05.22.
//

import Foundation
import Combine
import GymspotKit
import Resolver
import ComboPicker

extension SetCell {
  public final class ExerciseValueFormatter: ValueFormatterType {
    private let valueType: ValueType
    private let baseFormatter: ExerciseValueFormatterType
    
    init(valueType: ValueType, baseFormatter: ExerciseValueFormatterType) {
      self.valueType = valueType
      self.baseFormatter = baseFormatter
    }
    
    public func string(from value: DraftValue) -> String {
      baseFormatter.string(forValue: value.value, ofType: valueType) ?? "\(value)"
    }
  }
  
  struct DraftExerciseValue: Identifiable, Equatable, Hashable {
    let id = UUID()
    let type: ValueType
    var value: DraftValue
  }
  
  struct DraftValue: ComboPickerModel {
    let id = UUID()
    var value: Double
    
    init(value: Double) {
      self.value = value
    }
    
    init?(customValue: String) {
      guard
        let value = NumberFormatter().number(from: customValue)?.doubleValue
      else { return nil }
      
      self.init(value: value)
    }
    
    var valueForManualInput: String? {
      NumberFormatter().string(from: .init(value: value))
    }
  }
  
  final class SetCellViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var predefinedValuesProvider: PredefinedValuesProviderType
    @Injected private var exerciseValueFormatter: ExerciseValueFormatterType
    
    // MARK: - Identification
    let id = UUID()
    
    // MARK: - Published State
    @Published var index = 0
    @Published var values = [SetCell.DraftExerciseValue]()
    @Published var isValid = false
    
    // MARK: - Initializer
    init(index: Int = 0, values: [ExerciseValue] = []) {
      self.index = index
      self.values = values.map {
        .init(
          type: $0.type,
          value: .init(value: $0.value)
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
      .init(
        index: index,
        name: nil, // TODO: add support for set names
        values: values.map {
          .init(
            type: $0.type,
            value: $0.value.value
          )
        }
      )
    }
    
    func predefinedValues(for valueType: ValueType) -> [DraftValue] {
      predefinedValuesProvider.predefinedValues(for: valueType)
        .map {
          .init(value: $0)
        }
    }
    
    func formatter(for valueType: ValueType) -> ExerciseValueFormatter {
      ExerciseValueFormatter(
        valueType: valueType,
        baseFormatter: exerciseValueFormatter
      )
    }
  }
}

extension SetCell.SetCellViewModel: Identifiable { }
