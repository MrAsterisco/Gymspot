//
//  ExerciseDetailView.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import SwiftUI

struct ExerciseDetailView: View {
  let exerciseId: String
  
  @StateObject private var viewModel = ExerciseDetailViewModel()
  
  @State private var isEditing = false
  @State private var isDeleting = false
  
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    List {
      Section("Notes") {
        Text(viewModel.exercise?.notes ?? "")
      }
      
      Section("Links") {
        Button("Search on Google", action: { })
        Button("View on YouTube", action: { })
      }
      
      Section("Actions") {
        Button(role: .destructive, action: { isDeleting.toggle() }) {
          Text("Delete Exercise")
        }
      }
    }
    .navigationTitle(viewModel.exercise?.name ?? "")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: { isEditing.toggle() }) {
          Text("Edit")
        }
      }
    }
    .onAppear {
      viewModel.load(exercise: exerciseId)
    }
    .sheet(isPresented: $isEditing) { AddExerciseView(mode: .editing(exerciseId)) }
    .alert("Delete \"\(viewModel.exercise?.name ?? "\"")", isPresented: $isDeleting, actions: {
      Button(role: .cancel, action: { }) { Text("Cancel") }
      Button(role: .destructive, action: { deleteExercise() }) { Text("Delete") }
    }) {
      Text("This exercise will be removed from all workout routines and all related stats will be deleted.")
    }
  }
}

private extension ExerciseDetailView {
  func deleteExercise() {
    do {
      try viewModel.delete(exercise: exerciseId)
    } catch {
      print("Error: \(error)")
    }
    presentationMode.wrappedValue.dismiss()
  }
}

struct ExerciseDetailView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseDetailView(exerciseId: "")
  }
}
