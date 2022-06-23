//
//  ConfigureExerciseView.swift
//  Gymspot
//
//  Created by Alessio Moiso on 09.05.22.
//

import SwiftUI
import GymspotKit

typealias ConfigureExerciseCompletionHandler = (ExerciseDefinition) -> ()

struct ConfigureExerciseView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let mode: Mode
  let completionHandler: ConfigureExerciseCompletionHandler?
  @StateObject private var viewModel = ConfigureExerciseViewModel()
  
  init(
    mode: Mode,
    completionHandler: ConfigureExerciseCompletionHandler? = nil
  ) {
    self.mode = mode
    self.completionHandler = completionHandler
  }
  
  var body: some View {
    Form {
      Section("Exercise") {
        NavigationLink(
          destination: {
            ExercisesListView(
              mode: .picker(viewModel.exercise?.id),
              completionHandler: viewModel.receive(exercise:)
            )
          },
          label: {
            Text(viewModel.exercise?.name ?? "Select Exercise")
              .foregroundColor(.accentColor)
          }
        )
      }
      
      Section(
        content: {
          Picker(
            "Rest for",
            selection: $viewModel.restTime
          ) {
            Text("0:30")
              .tag(30)
            Text("1:00")
              .tag(60)
            Text("1:30")
              .tag(90)
            Text("2:00")
              .tag(120)
            Text("2:30")
              .tag(150)
            Text("3:00")
              .tag(180)
            Text("4:00")
              .tag(240)
            Text("5:00")
              .tag(300)
          }
        },
        header: {
          Text("Rest")
        },
        footer: {
          Text("This setting controls the rest time between sets. You can also increase or decrease the rest time during a workout.")
        }
      )
      
      Section("Sets") {
        List {
          ForEach(viewModel.setViewModels.indices, id: \.self) { index in
            SetCell(viewModel: $viewModel.setViewModels[index])
          }
          .onMove(perform: viewModel.moveSet(from:to:))
          .onDelete(perform: viewModel.removeSet(indexSet:))
        }
        
        Button(action: { viewModel.addSet() }) {
          Text("Add Set")
        }
      }
    }
    .navigationTitle(mode.navigationTitle)
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Cancel", action: { presentationMode.wrappedValue.dismiss() })
      }
      
      ToolbarItem(placement: .primaryAction) {
        Button(action: invokeCompletionHandler) {
          Text(mode.primaryAction)
            .bold()
        }
        .disabled(!viewModel.isValid)
      }
    }
    .onAppear {
      guard case let Mode.edit(exerciseDefinition) = mode else { return }
      viewModel.receive(exerciseDefinition: exerciseDefinition)
    }
    .environment(\.editMode, Binding.constant(EditMode.active))
  }
}

private extension ConfigureExerciseView {
  func invokeCompletionHandler() {
    guard let exerciseInstance = viewModel.createExerciseInstance() else { return }
    completionHandler?(exerciseInstance)
    presentationMode.wrappedValue.dismiss()
  }
}

private extension ConfigureExerciseView.Mode {
  var navigationTitle: LocalizedStringKey {
    switch self {
    case .add:
      return "Add Exercise"
    case .edit:
      return "Edit Exercise"
    }
  }
  
  var primaryAction: LocalizedStringKey {
    switch self {
    case .add:
      return "Add"
    case .edit:
      return "Update"
    }
  }
}

struct ConfigureExercise_Previews: PreviewProvider {
  static var previews: some View {
    mock {
      NavigationView {
        ConfigureExerciseView(mode: .add)
      }
    }
  }
}
