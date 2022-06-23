//
//  RoutineExerciseCell.swift
//  Gymspot
//
//  Created by Alessio Moiso on 15.05.22.
//

import SwiftUI
import GymspotKit

struct RoutineExerciseCell: View {
  @StateObject private var viewModel = RoutineExerciseCellViewModel()
  
  let workoutStep: WorkoutStep
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 12) {
        Image(systemName: "figure.walk")
        
        VStack(alignment: .leading) {
          Text(viewModel.title)
            .font(.title)
            .bold()
          
          Button(action: { }) {
            Text("View Notes")
              .font(.caption)
          }
        }
      }
      
      HStack(spacing: 12) {
        Text(viewModel.setName)
        
        Spacer()
        
        LazyHStack {
          ForEach($viewModel.values, id: \.self) { value in
            VStack {
              Text(value.wrappedValue.type.localizedName)
                .font(.caption)
                .bold()
                .foregroundColor(.secondary)
              
              Text(value.wrappedValue.representedValue)
            }
          }
        }
      }
      .padding(.top)
    }
    .padding([.top, .bottom], 4)
    .onAppear {
      viewModel.receive(step: workoutStep)
    }
  }
}

struct RoutineExerciseCell_Previews: PreviewProvider {
  static var previews: some View {
    RoutineExerciseCell(
      workoutStep: .init(index: 0, kind: .rest)
    )
  }
}
