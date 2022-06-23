//
//  WorkoutsTabViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 29.05.22.
//

import Foundation
import Resolver
import GymspotKit

extension WorkoutsTab {
  final class WorkoutsTabViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var workoutsManager: WorkoutsManagerType
    @Injected private var workoutRoutinesManager: WorkoutRoutinesManagerType
    @Injected private var foldersRepository: FoldersRepositoryType
    
    // MARK: - Published State
    @Published var activeWorkouts = [Workout]()
    @Published var routines = [GroupedItem]()
    
    @Published var selectedWorkout: Workout?
    @Published var folderName = ""
    
    @Published var selectedFolderId: String?
    
    // MARK: - Initializer
    override init() {
      super.init()
      observeData()
    }
    
    // MARK: - Actions
    func select(workout: Workout) {
      selectedWorkout = workout
    }
    
    func createFolder() {
      do {
        try foldersRepository.add(
          folder: .init(name: folderName)
        )
        folderName = ""
      } catch {
        print("Error: \(error)")
      }
    }
    
    func select(folderWithId id: String, with name: String? = nil) {
      selectedFolderId = id
      folderName = name ?? ""
    }
    
    func updateFolder() {
      guard let selectedFolderId = selectedFolderId else { return }
      
      Task {
        do {
          guard
            var folder = try await foldersRepository.folder(withId: selectedFolderId).firstValue()
          else { return }
          
          folder.name = folderName
          
          try foldersRepository.update(folder: folder)
        }
      }
    }
    
    func deleteFolder() {
      guard let candidateForDeletion = selectedFolderId else { return }
      
      Task {
        do {
          try await workoutRoutinesManager.delete(folderWithId: candidateForDeletion)
        } catch {
          print("Error: \(error)")
        }
      }
    }
  }
}

private extension WorkoutsTab.WorkoutsTabViewModel {
  func observeData() {
    workoutRoutinesManager.all
      .replaceError(with: [])
      .assign(to: &$routines)
    
    workoutsManager.activeWorkouts
      .replaceError(with: [])
      .assign(to: &$activeWorkouts)
  }
}
