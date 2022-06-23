//
//  AddRoutineViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 10.05.22.
//

import Foundation
import Combine
import Resolver
import GymspotKit

extension AddRoutineView {
  enum Mode {
    case  adding,
          editing(String)
  }
  
  final class AddRoutineViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var exercisesRepository: ExercisesRepositoryType
    @Injected private var workoutRoutinesRepository: WorkoutRoutinesRepositoryType
    @Injected private var foldersRepository: FoldersRepositoryType
    
    // MARK: - Published State
    @Published var name = ""
    @Published var folder: Folder?
    @Published var exercises = [ExerciseDefinition]()
    @Published var isValid = false
    
    // MARK: - Internal State
    private var workoutRoutineId: String?
    
    // MARK: - Initializer
    override init() {
      super.init()
      observeDataValidity()
    }
    
    // MARK: - Actions
    func load(workoutRoutineId: String) {
      self.workoutRoutineId = workoutRoutineId
      
      Task {
        do {
          guard
            let value = try await workoutRoutinesRepository.workoutRoutine(withId: workoutRoutineId).firstValue()
          else { return }
          
          let folder: Folder?
          if let folderId = value.folderId {
            folder = try await foldersRepository.folder(withId: folderId).firstValue()
          } else {
            folder = nil
          }
          
          await MainActor.run { [weak self] in
            self?.name = value.name
            self?.folder = folder
            self?.exercises = value.exercises
          }
        }
      }
    }
    
    func receive(folder: Folder) {
      self.folder = folder
    }
    
    func addOrUpdate(exerciseDefinition: ExerciseDefinition) {
      var exerciseToAdd = exerciseDefinition
      let computedIndex = exerciseDefinition.index ?? exercises.count
      var newExercises = exercises
      
      if let index = exerciseDefinition.index {
        newExercises.remove(at: index)
      } else {
        exerciseToAdd.index = computedIndex
      }
      
      newExercises.insert(exerciseToAdd, at: computedIndex)
      exercises = newExercises
    }
    
    func save() {
      let routine = WorkoutRoutine(
        id: workoutRoutineId,
        name: name,
        exercises: exercises,
        folderId: folder?.id
      )
      
      do {
        if workoutRoutineId != nil {
          try workoutRoutinesRepository.update(workoutRoutine: routine)
        } else {
          try workoutRoutinesRepository.add(workoutRoutine: routine)
        }
      } catch {
        print("Error: \(error)")
      }
    }
  }
}

// MARK: - Business Logic
private extension AddRoutineView.AddRoutineViewModel {
  func observeDataValidity() {
    Publishers.CombineLatest(
      $name,
      $exercises
    )
    .map { !$0.isEmpty && $1.count > 0 }
    .assign(to: &$isValid)
  }
}
