//
//  SelectableCell.swift
//  Gymspot
//
//  Created by Alessio Moiso on 12.06.22.
//

import SwiftUI

struct SelectableCell: View {
  let text: String
  let isSelected: Bool
  let selectionHandler: (() -> ())?
  
  var body: some View {
    HStack {
      Button(action: { selectionHandler?() }) {
        Text(text)
          .foregroundColor(isSelected ? .accentColor : .primary)
      }
      
      if isSelected {
        Spacer()
        Image(systemName: "checkmark")
          .foregroundColor(.accentColor)
      }
    }
  }
}

struct SelectableCell_Previews: PreviewProvider {
  static var previews: some View {
    SelectableCell(
      text: "Some Text",
      isSelected: true,
      selectionHandler: nil
    )
  }
}
