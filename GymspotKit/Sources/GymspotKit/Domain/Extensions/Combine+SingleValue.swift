//
//  Combine+SingleValue.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import Foundation
import Combine

public enum PublisherError: Error {
  case noValues
}

public extension Publisher {
  func firstValue() async throws -> Output {
    for try await output in values {
      return output
    }
    throw PublisherError.noValues
  }
}
