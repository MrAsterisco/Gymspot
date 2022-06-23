//
//  Cell.swift
//  Gymspot
//
//  Created by Alessio Moiso on 09.05.22.
//

import SwiftUI

struct Cell: View {
  let icon: Image?
  let title: String
  let subtitle: String?
  
  init(icon: Image? = nil, title: String, subtitle: String? = nil) {
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
  }
  
  var body: some View {
    HStack {
      if let icon = icon {
        icon
      }
      
      VStack(alignment: .leading, spacing: 0) {
        Text(title)
        
        if let subtitle = subtitle {
          Text(subtitle)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct DetailCell_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Cell(
        icon: .init(systemName: "figure.walk"),
        title: "Start Legs",
        subtitle: "Suggested Workout based on the day"
      )
      
      Cell(
        title: "Chest",
        subtitle: "Last performed 2 days ago"
      )
      
      Cell(
        icon: .init(systemName: "folder.fill"),
        title: "Legs"
      )
      
      Cell(
        title: "Shoulders"
      )
    }
  }
}
