//
//  ExercisesTabView.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import SwiftUI
import Resolver
import GymspotKit

typealias ExercisesPickerCompletionHandler = (Exercise) -> ()

struct ExercisesListView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let mode: Mode
  let completionHandler: ExercisesPickerCompletionHandler?
  
  @StateObject private var viewModel = ExercisesListViewModel()
  @State private var isAdding = false
  
  init(mode: Mode, completionHandler: ExercisesPickerCompletionHandler? = nil) {
    self.mode = mode
    self.completionHandler = completionHandler
  }
  
  var body: some View {
    List($viewModel.exercises) { $exercise in
      switch mode {
      case .showcase:
        NavigationLink(
          destination: { ExerciseDetailView(exerciseId: exercise.id!) },
          label: { Text(exercise.name) }
        )
      case let .picker(selectedExerciseId):
        SelectableCell(
          text: exercise.name,
          isSelected: exercise.id == selectedExerciseId,
          selectionHandler: {
            completionHandler?(exercise)
            presentationMode.wrappedValue.dismiss()
          }
        )
      }
    }
    .navigationTitle(mode.navigationTitle)
    .toolbar {
      Button(
        action: { isAdding.toggle() },
        label: { Image(systemName: "plus") }
      )
    }
    .sheet(isPresented: $isAdding) { AddExerciseView(mode: .adding) }
  }
}

private extension ExercisesListView.Mode {
  var navigationTitle: LocalizedStringKey {
    switch self {
    case .showcase:
      return "Exercises"
    case .picker:
      return "Choose Exercise"
    }
  }
}

struct ExercisesListView_Previews: PreviewProvider {
  static var previews: some View {
    mock {
      NavigationView {
        ExercisesListView(mode: .showcase)
      }
    }
  }
}
