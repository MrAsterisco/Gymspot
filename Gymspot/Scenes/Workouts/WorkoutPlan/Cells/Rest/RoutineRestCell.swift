//
//  RoutineRestCell.swift
//  Gymspot
//
//  Created by Alessio Moiso on 15.05.22.
//

import SwiftUI
import GymspotKit

struct RoutineRestCell: View {
  @State private var viewModel = RoutineRestCellViewModel()
  
  let workoutStep: WorkoutStep
  
  var body: some View {
    HStack {
      Image(systemName: "timer")
      
      Text("Rest")
        .font(.title3)
        .bold()
      
      Spacer()
      
      Text(viewModel.restTime)
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
  }
}

struct RoutineRestCell_Previews: PreviewProvider {
  static var previews: some View {
    RoutineRestCell(workoutStep: .init(index: 0, kind: .rest))
  }
}
