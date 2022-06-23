//
//  ConfigureExerciseViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 12.05.22.
//

import Foundation
import Combine
import Resolver
import GymspotKit

extension ConfigureExerciseView {
  enum Mode {
    case  add,
          edit(ExerciseDefinition)
  }
  
  final class ConfigureExerciseViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var exercisesRepository: ExercisesRepositoryType
    
    // MARK: - Published State
    @Published var exercise: Exercise?
    @Published var restTime = 90
    @Published var setViewModels = [SetCell.SetCellViewModel]()
    @Published var isValid = false
    
    // MARK: - Internal State
    var exerciseDefinitionIndex: Int?
    
    // MARK: - Initializer
    override init() {
      super.init()
      observeDataValidity()
    }
    
    // MARK: - Actions
    func receive(exerciseDefinition: ExerciseDefinition) {
      prefillDetails(from: exerciseDefinition)
    }
    
    func receive(exercise: Exercise) {
      self.exercise = exercise
      refreshWeightSettings()
    }
    
    func addSet() {
      setViewModels.append(
        SetCell.SetCellViewModel(
          index: setViewModels.count,
          values: exercise?.valueTypes.map {
            .init(
              type: $0,
              value: 0
            )
          } ?? []
        )
      )
    }
    
    func removeSet(indexSet: IndexSet) {
      indexSet.forEach { setViewModels.remove(at: $0) }
      refreshSetIndexes()
    }
    
    func createExerciseInstance() -> ExerciseDefinition? {
      guard
        let exerciseId = exercise?.id,
        !setViewModels.isEmpty
      else { return nil }

      let sets = setViewModels.map { $0.createSet() }
      
      return .init(
        index: exerciseDefinitionIndex,
        exerciseId: exerciseId,
        restTime: restTime,
        sets: sets
      )
    }
    
    func moveSet(from originalIndex: IndexSet, to index: Int) {
      setViewModels.move(fromOffsets: originalIndex, toOffset: index)
      setViewModels
        .enumerated()
        .forEach { (index, _) in
          setViewModels[index].index = index
        }
    }
  }
}

// MARK: - Business Logic
private extension ConfigureExerciseView.ConfigureExerciseViewModel {
  func observeDataValidity() {
    Publishers.CombineLatest(
      $exercise,
      $setViewModels
    )
    .map { $0 != nil && $1.count > 0 }
    .assign(to: &$isValid)
  }
  
  func prefillDetails(from exerciseDefinition: ExerciseDefinition) {
    exerciseDefinitionIndex = exerciseDefinition.index
    restTime = exerciseDefinition.restTime
    setViewModels = exerciseDefinition.sets
      .map { .init(exerciseSet: $0) }
    
    Task {
      do {
        let exercise = try await exercisesRepository.exercise(withId: exerciseDefinition.exerciseId).firstValue()
        await MainActor.run { [weak self] in
          self?.exercise = exercise
        }
      } catch {
        print("Error \(error)")
      }
    }
  }
  
  func refreshWeightSettings() {
    setViewModels.forEach { element in
      element.values = exercise?.valueTypes.map {
        .init(
          type: $0,
          draftValue: ""
        )
      } ?? []
    }
  }
  
  func refreshSetIndexes() {
    setViewModels.enumerated().forEach { (index, element) in
      element.index = index
    }
  }
}
