//
//  GroupedItem.swift
//  
//
//  Created by Alessio Moiso on 11.06.22.
//

import Foundation

public struct GroupedItem: Identifiable, Hashable {
  public let id: String
  public let name: String?
  public var children: [GroupedItem]?
}
