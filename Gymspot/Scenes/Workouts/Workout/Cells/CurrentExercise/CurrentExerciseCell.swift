//
//  CurrentExerciseCell.swift
//  Gymspot
//
//  Created by Alessio Moiso on 29.05.22.
//

import SwiftUI
import GymspotKit

struct CurrentExerciseCell: View {
  @StateObject private var viewModel = CurrentExerciseCellViewModel()
  
  let workoutStep: WorkoutStep
  let editCallback: (ValueType) -> ()
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Image(systemName: "figure.walk")
        
        VStack(alignment: .leading) {
          Text(viewModel.title)
            .font(.title)
            .bold()
          
          Text(viewModel.setName)
            .font(.callout)
            .bold()
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      LazyHStack {
        ForEach($viewModel.values, id: \.self) { value in
          VStack {
            Text(value.wrappedValue.type.localizedName)
              .font(.caption)
              .bold()
              .foregroundColor(.secondary)
            
            Text(value.wrappedValue.representedValue)
            
            Button(action: { editCallback(value.wrappedValue.type) }) {
              Text("EDIT")
                .font(.caption)
            }
          }
        }
      }
    }
    .frame(maxWidth: .infinity)
    .padding([.top, .bottom], 4)
    .onAppear {
      viewModel.receive(step: workoutStep)
    }
  }
}

struct CurrentExerciseCell_Previews: PreviewProvider {
  static var previews: some View {
    CurrentExerciseCell(
      workoutStep: .init(index: 0, kind: .exercise),
      editCallback: { _ in }
    )
  }
}
