//
//  ExercisesTab.swift
//  Gymspot
//
//  Created by Alessio Moiso on 12.05.22.
//

import SwiftUI

struct ExercisesTab: View {
  var body: some View {
    NavigationView {
      ExercisesListView(mode: .showcase)
    }
  }
}

struct ExercisesTab_Previews: PreviewProvider {
  static var previews: some View {
    ExercisesTab()
  }
}
