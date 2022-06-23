//
//  File.swift
//  
//
//  Created by Alessio Moiso on 11.06.22.
//

import Foundation
import Resolver

// MARK: - Business Logic
public extension Resolver {
  func registerRepositories() {
    register { ExercisesRepository(authenticationManager: $0.resolve()) }
      .implements(ExercisesRepositoryType.self)
      .scope(.application)
    
    register { WorkoutRoutinesRepository(authenticationManager: $0.resolve()) }
      .implements(WorkoutRoutinesRepositoryType.self)
      .scope(.application)
    
    register { WorkoutsRepository(authenticationManager: $0.resolve()) }
      .implements(WorkoutsRepositoryType.self)
      .scope(.application)
    
    register { FoldersRepository(authenticationManager: $0.resolve()) }
      .implements(FoldersRepositoryType.self)
      .scope(.application)
  }
  
  func registerBusinessLogic() {
    register { AuthenticationManager() }
      .implements(AuthenticationManagerType.self)
      .scope(.application)
    
    register { WorkoutGenerator(exercisesRepository: $0.resolve()) }
      .implements(WorkoutGeneratorType.self)
      .scope(.application)
    
    register { WorkoutsManager(workoutRoutinesRepository: $0.resolve(), workoutsRepository: $0.resolve(), workoutGenerator: $0.resolve()) }
      .implements(WorkoutsManagerType.self)
      .scope(.application)
    
    register { WorkoutRoutinesManager(workoutRoutinesRepository: $0.resolve(), foldersRepository: $0.resolve()) }
      .implements(WorkoutRoutinesManagerType.self)
      .scope(.application)
    
    register { StepsTimerManager(workoutsManager: $0.resolve()) }
      .implements(StepsTimerManagerType.self)
      .scope(.application)
  }
  
  func registerFormatters() {
    register { ValueFormatter() }
      .implements(ValueFormatterType.self)
      .scope(.application)
  }
}

#if DEBUG
// MARK: - Mocks
public extension Resolver {
  func registerMockRepositories() {
    register { MockExercisesRepository() }
      .implements(ExercisesRepositoryType.self)
      .scope(.application)
    
    register { MockFoldersRepository() }
      .implements(FoldersRepositoryType.self)
      .scope(.application)
    
    register { MockWorkoutRoutinesRepository() }
      .implements(WorkoutRoutinesRepositoryType.self)
      .scope(.application)
    
    register { MockWorkoutsRepository() }
      .implements(WorkoutsRepositoryType.self)
      .scope(.application)
  }
}
#endif
