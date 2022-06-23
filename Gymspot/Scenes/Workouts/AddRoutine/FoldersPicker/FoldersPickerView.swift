//
//  SelectFolderView.swift
//  Gymspot
//
//  Created by Alessio Moiso on 12.06.22.
//

import SwiftUI
import GymspotKit

typealias FoldersPickerCompletionHandler = (Folder) -> ()

struct FoldersPickerView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let selectedFolderId: String?
  let completionHandler: FoldersPickerCompletionHandler?
  
  @StateObject private var viewModel = FoldersPickerViewModel()
  @State private var isAdding = false
  
  init(selectedFolderId: String? = nil, completionHandler: FoldersPickerCompletionHandler? = nil) {
    self.selectedFolderId = selectedFolderId
    self.completionHandler = completionHandler
  }
  
  var body: some View {
    List($viewModel.folders) { $folder in
      SelectableCell(
        text: folder.name,
        isSelected: selectedFolderId == folder.id,
        selectionHandler: {
          completionHandler?(folder)
          presentationMode.wrappedValue.dismiss()
        }
      )
    }
    .navigationTitle("Select Folder")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(action: { isAdding.toggle() }) {
          Image(systemName: "plus")
        }
      }
    }
    .alert("New Folder", isPresented: $isAdding) {
      TextField("Name", text: $viewModel.folderName)
      
      Button(action: { }) {
        Text("Cancel")
      }
      
      Button(action: { viewModel.createFolder() }) {
        Text("Create")
          .bold()
      }
    }
  }
}

struct FoldersPickerView_Previews: PreviewProvider {
  static var previews: some View {
    mock {
      NavigationView {
        FoldersPickerView(selectedFolderId: "0")
      }
    }
  }
}
