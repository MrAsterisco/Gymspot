//
//  WorkoutsHistorySection.swift
//  Gymspot
//
//  Created by Alessio Moiso on 29.05.22.
//

import SwiftUI

struct WorkoutsHistoryView: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject private var viewModel = WorkoutsHistoryViewModel()
  
  var body: some View {
    NavigationView {
      List {
        if !viewModel.workouts.isEmpty {
          ForEach($viewModel.workouts, id: \.self) { workout in
            Text(workout.wrappedValue.name)
          }
        } else {
          Text("No Past Workouts")
            .foregroundColor(.secondary)
        }
      }
      .navigationTitle("Workouts History")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Text("Close")
          }
        }
      }
    }
  }
}

struct WorkoutsHistorySection_Previews: PreviewProvider {
  static var previews: some View {
    WorkoutsHistoryView()
  }
}
