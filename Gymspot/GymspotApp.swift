//
//  GymspotApp.swift
//  Gymspot
//
//  Created by Alessio Moiso on 05.05.22.
//

import SwiftUI
import Firebase
import Resolver


@main
struct GymspotApp: App {
  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      MainView()
    }
  }
}
