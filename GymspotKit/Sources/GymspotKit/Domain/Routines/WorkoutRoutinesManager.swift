//
//  WorkoutRoutinesManager.swift
//  
//
//  Created by Alessio Moiso on 11.06.22.
//

import Foundation
import Combine

final class WorkoutRoutinesManager: WorkoutRoutinesManagerType {
  private let workoutRoutinesRepository: WorkoutRoutinesRepositoryType
  private let foldersRepository: FoldersRepositoryType
  
  init(workoutRoutinesRepository: WorkoutRoutinesRepositoryType, foldersRepository: FoldersRepositoryType) {
    self.workoutRoutinesRepository = workoutRoutinesRepository
    self.foldersRepository = foldersRepository
  }
  
  var all: AnyPublisher<[GroupedItem], Error> {
    Publishers.CombineLatest(
      workoutRoutinesRepository.all,
      foldersRepository.all
    )
    .map { (routines: [WorkoutRoutine], folders: [Folder]) in
      folders.map { folder in
        GroupedItem(
          id: folder.id ?? "",
          name: folder.name,
          children: routines
            .filter { $0.folderId == folder.id }
            .map {
              .init(
                id: $0.id ?? "",
                name: $0.name,
                children: nil
              )
            }
        )
      } + routines
        .filter { $0.folderId == nil }
        .map {
          .init(
            id: $0.id ?? "",
            name: $0.name,
            children: nil
          )
        }
    }
    .map { $0.sorted(by: { ($0.name ?? "").localizedCaseInsensitiveCompare($1.name ?? "") == .orderedAscending }) }
    .eraseToAnyPublisher()
  }
  
  func workoutRoutine(withId id: String) -> AnyPublisher<WorkoutRoutine?, Error> {
    workoutRoutinesRepository.workoutRoutine(withId: id)
  }
  
  func add(workoutRoutine: WorkoutRoutine) throws {
    try workoutRoutinesRepository.add(workoutRoutine: workoutRoutine)
  }
  
  func update(workoutRoutine: WorkoutRoutine) throws {
    try workoutRoutinesRepository.update(workoutRoutine: workoutRoutine)
  }
  
  func delete(workoutRoutineWithId id: String) throws {
    try workoutRoutinesRepository.delete(workoutRoutineWithId: id)
  }
  
  func delete(folderWithId id: String) async throws {
    let routinesToUpdate = try await workoutRoutinesRepository.all
      .map { $0.filter { $0.folderId == id } }
      .firstValue()
      .map { routine -> WorkoutRoutine in
        var newRoutine = routine
        newRoutine.folderId = nil
        return newRoutine
      }
    
    try routinesToUpdate
      .forEach { try workoutRoutinesRepository.update(workoutRoutine: $0) }
    
    try foldersRepository.delete(folderWithId: id)
  }
}
