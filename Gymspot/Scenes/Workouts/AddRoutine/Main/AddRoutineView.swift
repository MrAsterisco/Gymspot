//
//  AddRoutineView.swift
//  Gymspot
//
//  Created by Alessio Moiso on 09.05.22.
//

import SwiftUI
import GymspotKit

struct AddRoutineView: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject private var viewModel = AddRoutineViewModel()
  @State private var isAddingExercise = false
  
  let mode: Mode
  
  var body: some View {
    NavigationView {
      Form {
        Section("General") {
          TextField("Name", text: $viewModel.name)
          NavigationLink(
            destination: {
              FoldersPickerView(
                selectedFolderId: viewModel.folder?.id,
                completionHandler: didSelect(folder:)
              )
            }
          ){
            HStack {
              Text("Folder")
              Spacer()
              Text(viewModel.folder?.name ?? "None")
                .foregroundColor(.secondary)
            }
          }
        }
        
        Section("Exercises") {
          ForEach($viewModel.exercises, id: \.self) { definition in
            NavigationLink(
              destination: {
                ConfigureExerciseView(
                  mode: .edit(definition.wrappedValue),
                  completionHandler: didConfigure(exercise:)
                )
              }) {
                ExerciseDefinitionCell(
                  viewModel: .init(definition: definition.wrappedValue)
                )
              }
          }
          
          Button(action: { isAddingExercise.toggle() }) {
            Text("Add Exercise")
          }
        }
      }
      .navigationTitle(mode.navigationTitle)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: { presentationMode.wrappedValue.dismiss() })
        }
        
        ToolbarItem(placement: .primaryAction) {
          Button(action: createOrUpdate) {
            Text(mode.buttonTitle)
              .bold()
          }
          .disabled(!viewModel.isValid)
        }
      }
    }
    .sheet(isPresented: $isAddingExercise) {
      NavigationView {
        ConfigureExerciseView(
          mode: .add,
          completionHandler: didConfigure(exercise:)
        )
      }
    }
    .onAppear {
      loadIfNeeded()
    }
  }
}

private extension AddRoutineView {
  func loadIfNeeded() {
    guard
      case let Mode.editing(workoutRoutineId) = mode
    else { return }
    
    viewModel.load(workoutRoutineId: workoutRoutineId)
  }
  
  func didConfigure(exercise: ExerciseDefinition) {
    viewModel.addOrUpdate(exerciseDefinition: exercise)
  }
  
  func didSelect(folder: Folder) {
    viewModel.receive(folder: folder)
  }
  
  func createOrUpdate() {
    viewModel.save()
    presentationMode.wrappedValue.dismiss()
  }
}

private extension AddRoutineView.Mode {
  var navigationTitle: LocalizedStringKey {
    switch self {
    case .adding:
      return "Add Routine"
    case .editing:
      return "Edit Routine"
    }
  }
  
  var buttonTitle: LocalizedStringKey {
    switch self {
    case .adding:
      return "Add"
    case .editing:
      return "Save"
    }
  }
}

struct AddRoutine_Previews: PreviewProvider {
  static var previews: some View {
    mock {
      AddRoutineView(mode: .adding)
    }
  }
}
