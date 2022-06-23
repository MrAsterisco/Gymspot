//
//  CurrentRestCell.swift
//  Gymspot
//
//  Created by Alessio Moiso on 03.06.22.
//

import SwiftUI
import ConcaveProgressView

struct CurrentRestCell: View {
  @StateObject private var viewModel = CurrentRestCellViewModel()
  
  let workoutId: String
  let stepIndex: Int
  
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Image(systemName: "timer")
        
        VStack(alignment: .leading) {
          Text("Rest")
            .font(.title)
            .bold()
          
          Text(viewModel.totalTime)
            .font(.callout)
            .bold()
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      ZStack {
        ConcaveProgressBar(value: viewModel.currentProgress)
          .barStyle(.init(lineWidth: 8, lineCap: .round, lineJoin: .round))
          .foreground(.accentColor)
          .background(.secondary.opacity(0.3))
          .frame(height: 60)
        
        Text(viewModel.currentTime)
          .font(.title2)
          .bold()
          .padding(.top)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .onAppear {
      viewModel.load(stepAt: stepIndex, inWorkout: workoutId)
    }
  }
}

struct CurrentRestCell_Previews: PreviewProvider {
  static var previews: some View {
    CurrentRestCell(workoutId: "", stepIndex: 0)
  }
}
