//
//  File.swift
//  
//
//  Created by Oliver Hunt on 3/19/22.
//

import Foundation

public protocol IterableAxis {
  associatedtype AllAxes: Collection where AllAxes.Element == Self
  static var allAxes: AllAxes { get }
}

public extension CaseIterable where Self: IterableAxis {
  typealias AllAxes = Self.AllCases
  static var allAxes: Self.AllCases { Self.allCases }
}
