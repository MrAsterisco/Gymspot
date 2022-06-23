//
//  ComingUpExerciseCell.swift
//  Gymspot
//
//  Created by Alessio Moiso on 29.05.22.
//

import Foundation
import SwiftUI
import GymspotKit

struct ComingUpExerciseCell: View {
  @StateObject private var viewModel = ComingUpExerciseViewModel()
  
  let workoutStep: WorkoutStep
  
  var body: some View {
    Cell(
      icon: viewModel.icon,
      title: viewModel.title,
      subtitle: viewModel.subtitle
    )
    .onAppear {
      viewModel.receive(step: workoutStep)
    }
  }
}

struct ComingUpExerciseCell_Previews: PreviewProvider {
  static var previews: some View {
    ComingUpExerciseCell(
      workoutStep: .init(index: 0, kind: .rest)
    )
  }
}
