//
//  ExerciseDefinitionCell.swift
//  Gymspot
//
//  Created by Alessio Moiso on 15.05.22.
//

import SwiftUI
import GymspotKit

struct ExerciseDefinitionCell: View {
  @StateObject var viewModel: ExerciseDefinitionCellViewModel
  
  var body: some View {
    Cell(
      title: viewModel.exerciseName,
      subtitle: viewModel.definition.subtitle
    )
  }
}

private extension ExerciseDefinition {
  var subtitle: String {
    "\(sets.count) sets"
  }
}

struct ExerciseDefinitionCell_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseDefinitionCell(
      viewModel: .init(definition: .init(exerciseId: "", restTime: 0, sets: []))
    )
  }
}
