//
//  FoldersPickerViewModel.swift
//  Gymspot
//
//  Created by Alessio Moiso on 12.06.22.
//

import Foundation
import Resolver
import GymspotKit

extension FoldersPickerView {
  final class FoldersPickerViewModel: ViewModel {
    // MARK: - Dependencies
    @Injected private var foldersRepository: FoldersRepositoryType
    
    // MARK: - Published State
    @Published var folders = [Folder]()
    
    @Published var folderName = ""
    
    // MARK: - Initializer
    override init() {
      super.init()
      observeData()
    }
    
    // MARK: - Actions
    func createFolder() {
      do {
        try foldersRepository.add(
          folder: .init(name: folderName)
        )
        folderName = ""
      } catch {
        print("Error: \(error)")
      }
    }
  }
}

private extension FoldersPickerView.FoldersPickerViewModel {
  func observeData() {
    foldersRepository.all
      .replaceError(with: [])
      .assign(to: &$folders)
  }
}
