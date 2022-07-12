//
//  WorkoutsTab.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import SwiftUI
import GymspotKit

struct WorkoutsTab: View {
  @StateObject private var viewModel = WorkoutsTabViewModel()
  
  @State private var isAdding = false
  @State private var isAddingFolder = false
  @State private var isEditingFolder = false
  @State private var isDeletingFolder = false
  @State private var isShowingHistory = false
  
  var body: some View {
    NavigationView {
      List {
        if !viewModel.activeWorkouts.isEmpty {
          Section {
            ForEach($viewModel.activeWorkouts) { $workout in
              Button(action: {
                viewModel.select(workout: workout)
              }) {
                HStack(alignment: .center) {
                  Text(workout.name)
                    .foregroundColor(.black)
                    .bold()
                  
                  Spacer()
                  
                  Text(workout.state.label ?? "")
                    .foregroundColor(.black)
                    .font(.caption2)
                    .bold()
                }
              }
              .listRowBackground(workout.state.background)
            }
          }
        }
        
        Section {
          Text("Start Empty Workout")
        } header: {
          Text("Quick Start")
            .headerProminence(.increased)
        }
        
        Section {
          OutlineGroup($viewModel.routines, id: \.self, children: \.children) { $item in
            switch item.kind {
            case .folder:
              Cell(
                icon: Image(systemName: "folder.fill"),
                title: item.name ?? ""
              )
              .swipeActions {
                Button(action: {
                  viewModel.select(folderWithId: item.id)
                  isDeletingFolder.toggle()
                }) {
                  Image(systemName: "trash")
                  Text("Delete")
                }
                .tint(.red)
                
                Button(action: {
                  viewModel.select(folderWithId: item.id, with: item.name)
                  isEditingFolder.toggle()
                }) {
                  Image(systemName: "pencil")
                  Text("Edit")
                }
              }
            case .routine:
              NavigationLink(
                destination: {
                  WorkoutPlanView(
                    workoutRoutineId: item.id,
                    startWorkoutHandler: nil
                  )
                }
              ){
                Cell(
                  icon: Image(systemName: "figure.walk.circle.fill"),
                  title: item.name ?? ""
                )
              }
            }
          }
        } header: {
          Text("Routines")
            .headerProminence(.increased)
        }
      }
      .navigationTitle("Workout")
      .toolbar {
        ToolbarItemGroup(placement: .primaryAction) {
          Button(action: { isShowingHistory.toggle() }) {
            Image(systemName: "clock.arrow.circlepath")
          }
          
          Menu {
            Button(action: { isAddingFolder.toggle() }) {
              Image(systemName: "folder")
              Text("New Folder")
            }
            
            Button(action: { isAdding.toggle() }) {
              Image(systemName: "figure.walk")
              Text("New Routine")
            }
          } label: {
            Image(systemName: "plus")
          }
        }
      }
    }
    .fullScreenCover(item: $viewModel.selectedWorkout) { workout in
      WorkoutView(workoutId: workout.id ?? "")
    }
    .sheet(isPresented: $isShowingHistory) { WorkoutsHistoryView() }
    .sheet(isPresented: $isAdding) { AddRoutineView(mode: .adding) }
    .alert(
      "New Folder",
      isPresented: $isAddingFolder
    ){
      TextField("Name", text: $viewModel.folderName)
      
      Button(action: { }) {
        Text("Cancel")
      }
      Button(action: { viewModel.createFolder() }) {
        Text("Create")
          .bold()
      }
    }
    .confirmationDialog(
      "Delete Folder",
      isPresented: $isDeletingFolder,
      presenting: viewModel.selectedFolderId,
      actions: { folder in
        Button(role: .destructive, action: { viewModel.deleteFolder() }) {
          Text("Delete")
        }
      },
      message: { _ in
        Text("The routines in this folder will not be deleted.")
      }
    )
    .alert(
      "Edit Folder",
      isPresented: $isEditingFolder,
      presenting: viewModel.selectedFolderId,
      actions: { _ in
        TextField("Name", text: $viewModel.folderName)
        
        Button(action: { }) {
          Text("Cancel")
        }
        
        Button(action: viewModel.updateFolder) {
          Text("Update")
            .bold()
        }
      }
    )
  }
}

private extension GroupedItem {
  enum Kind {
    case  folder,
          routine
  }
  
  var kind: Kind {
    children != nil ? .folder : .routine
  }
}

private extension Workout.State {
  var background: Color? {
    switch self {
    case .running:
      return Color("Start")
    case .paused:
      return Color("Pause")
    default:
      return nil
    }
  }
  
  var label: LocalizedStringKey? {
    switch self {
    case .running:
      return "ACTIVE"
    case .paused:
      return "PAUSED"
    default:
      return nil
    }
  }
}

struct WorkoutsTab_Previews: PreviewProvider {
  static var previews: some View {
    mock {
      WorkoutsTab()
    }
  }
}
