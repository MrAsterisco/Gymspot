//
//  AddExerciseView.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import SwiftUI


struct AddExerciseView: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject private var viewModel = AddExerciseViewModel()
  
  let mode: Mode
  
  var body: some View {
    NavigationView {
      List {
        Section("Name") {
          TextField("Name", text: $viewModel.name)
        }
        
        Section(content: {
          Picker("Weight Effect", selection: $viewModel.weightEffectIndex) {
            Text("Adds Difficulty")
              .tag(0)
            Text("Subtracts Difficulty")
              .tag(1)
            Text("Not used")
              .tag(2)
          }
          .pickerStyle(.segmented)
        }, header: {
          Text("Weight")
        }, footer: {
          Text("Configure how adding or subtracting weight affects this exercise. You can also turn off weight tracking completely.")
        })
        
        Section("Notes") {
          TextEditor(text: $viewModel.notes)
            .frame(height: 120)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(mode.navigationTitle)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: { presentationMode.wrappedValue.dismiss() })
        }
        
        ToolbarItem(placement: .primaryAction) {
          Button(action: createOrUpdate) {
            Text(mode.buttonTitle)
              .bold()
          }
        }
      }
    }
    .onAppear {
      loadIfNeeded()
    }
  }
}

private extension AddExerciseView {
  func loadIfNeeded() {
    guard
      case let Mode.editing(exerciseId) = mode
    else { return }
    
    viewModel.load(exerciseId: exerciseId)
  }
  
  func createOrUpdate() {
    viewModel.save()
    presentationMode.wrappedValue.dismiss()
  }
}

private extension AddExerciseView.Mode {
  var navigationTitle: LocalizedStringKey {
    switch self {
    case .adding:
      return "Add Exercise"
    case .editing:
      return "Edit Exercise"
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

struct AddExercise_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AddExerciseView(mode: .adding)
    }
  }
}
