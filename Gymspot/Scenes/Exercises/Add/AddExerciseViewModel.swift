//
//  AddExerciseViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import Foundation
import Resolver
import GymspotKit

extension AddExerciseView {
  enum Mode {
    case  adding,
          editing(String)
  }
  
  final class AddExerciseViewModel: ObservableObject {
    // MARK: - Dependencies
    @Injected private var exercisesRepository: ExercisesRepositoryType
    
    // MARK: - Published State
    @Published var name = ""
    @Published var weightEffectIndex = 0
    @Published var notes = ""
    
    // MARK: - Internal State
    private var exerciseId: String?
    
    // MARK: - Actions
    func load(exerciseId: String) {
      self.exerciseId = exerciseId
      
      Task {
        do {
          guard
            let value = try await exercisesRepository.exercise(withId: exerciseId).firstValue()
          else { return }
          
          await MainActor.run { [weak self] in
            self?.name = value.name
            self?.weightEffectIndex = weightEffectIndex(from: value.valueTypes)
            self?.notes = value.notes
          }
        } catch {
          print("Error \(error)")
        }
      }
    }
    
    func save() {
      let exercise = Exercise(
        id: exerciseId,
        name: name,
        valueTypes: valueTypes(for: weightEffectIndex) + valueTypesForKeyMetric(),
        notes: notes
      )
      
      do {
        if exerciseId != nil {
          try exercisesRepository.update(exercise: exercise)
        } else {
          try exercisesRepository.add(exercise: exercise)
        }
      } catch {
        print("Error: \(error)")
      }
    }
  }
}

// MARK: - Business Logic
private extension AddExerciseView.AddExerciseViewModel {
  func weightEffectIndex(from valueTypes: [ValueType]) -> Int {
    if valueTypes.firstIndex(of: .positiveWeight) != nil {
      return 0
    } else if valueTypes.firstIndex(of: .negativeWeight) != nil {
      return 1
    }
    return 2
  }
  
  func valueTypes(for weightEffectIndex: Int) -> [ValueType] {
    switch weightEffectIndex {
    case 0:
      return [.positiveWeight]
    case 1:
      return [.negativeWeight]
    default:
      return []
    }
  }
  
  // TODO: add support for time metric
  func valueTypesForKeyMetric() -> [ValueType] {
    [.reps]
  }
}
