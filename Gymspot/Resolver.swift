//
//  Resolver.swift
//  Gymspot
//
//  Created by Alessio Moiso on 05.05.22.
//

import Foundation
import Resolver
import GymspotKit
import SwiftUI

// MARK: - Business Logic
extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    configureMainContainer()
    #if DEBUG
    configureMockContainer()
    #endif
  }
}

private extension Resolver {
  static func configureMainContainer() {
    Resolver.main.registerRepositories()
    Resolver.main.registerBusinessLogic()
    Resolver.main.registerFactories()
    Resolver.main.registerFormatters()
  }
  
  #if DEBUG
  static func configureMockContainer() {
    Resolver.mock.registerMockRepositories()
    Resolver.mock.registerBusinessLogic()
    Resolver.mock.registerFactories()
    Resolver.mock.registerFormatters()
  }
  #endif
}

private extension Resolver {
  func registerFactories() {
    register { StepCellFactory() }
      .implements(StepCellFactoryType.self)
      .scope(.application)
  }
}

#if DEBUG
// MARK: - Mocks
extension Resolver {
  static let mock = Resolver()
}
#endif

extension PreviewProvider {
  static func mock(for content: () -> some View) -> AnyView {
#if DEBUG
    Resolver.root = Resolver.mock
#endif
    return AnyView(content())
  }
}
