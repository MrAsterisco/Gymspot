//
//  SetCell.swift
//  Gymspot
//
//  Created by Alessio Moiso on 09.05.22.
//

import SwiftUI
import GymspotKit
import ComboPicker

struct SetCell: View {
  @Binding var viewModel: SetCellViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      Text("Set \(viewModel.index + 1)")
      
      HStack(spacing: 2) {
        ForEach($viewModel.values) { $value in
          VStack(spacing: 4) {
            Text(value.type.localizedName.uppercased())
              .font(.caption2)
              .bold()
              .foregroundColor(.secondary)
              .fixedSize()
            
            ComboPicker(
              title: value.type.localizedName,
              manualTitle: "",
              valueFormatter: viewModel.formatter(for: value.type),
              content: .constant(viewModel.predefinedValues(for: value.type)),
              value: $value.value.value
            )
            .keyboardType(.numberPad)
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding([.top, .bottom], 4)
  }
}

struct SetCell_Previews: PreviewProvider {
  private static let data: [ExerciseSetDefinition] = [
    .init(
      index: 0,
      name: "Set 1",
      values: [
        .init(type: .positiveWeight, value: 35),
        .init(type: .reps, value: 15)
      ]
    ),
    .init(
      index: 1,
      name: "Set 2",
      values: [
        .init(type: .reps, value: 15)
      ]
    )
  ]
  
  static var previews: some View {
    NavigationView {
      List {
        ForEach(Self.data) { item in
          SetCell(
            viewModel: .constant(
              .init(
                exerciseSet: item
              )
            )
          )
        }
        .onMove(perform: { (_, _) in })
        .onDelete(perform: { _ in })
      }
      .navigationTitle("Sets")
      .navigationBarTitleDisplayMode(.inline)
      .environment(\.editMode, .constant(.active))
    }
  }
}
