//
//  ContentView.swift
//  Gymspot
//
//  Created by Alessio Moiso on 05.05.22.
//

import SwiftUI

struct MainView: View {
  @StateObject var viewModel = MainViewModel()
  
  var body: some View {
    if viewModel.isLoggedIn {
      TabView {
        WorkoutsTab()
          .tabItem {
            Image(systemName: "list.bullet.rectangle.portrait.fill")
            Text("Workout")
          }
        
        ExercisesTab()
          .tabItem {
            Image(systemName: "heart.text.square.fill")
            Text("Exercises")
          }
      }
      .onAppear {
        viewModel.beginObservingTimers()
      }
    } else {
      LoginView()
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
