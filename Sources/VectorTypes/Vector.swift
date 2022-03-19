//
//  File.swift
//  
//
//  Created by Oliver Hunt on 3/19/22.
//

import Foundation

public protocol Vector : IndexableVector {
  associatedtype MaskType: Mask where MaskType.AxisType == AxisType
  
  subscript(_ axis: AxisType) -> ValueType { get }
  func length() -> ValueType
  func replace(with other: Self, where c: MaskType) -> Self
  func minElement() -> ValueType
  func maxElement() -> ValueType
  
  static func random() -> Self
  static func random(_ radius: ValueType) -> Self
  static func - (left: Self, right: Self) -> Self
  static func + (left: Self, right: Self) -> Self
  static func * (left: Self, right: ValueType) -> Self
  static func * (left: ValueType, right: Self) -> Self
  static func / (left: Self, right: ValueType) -> Self
  static prefix func -(right: Self) -> Self
  static func .* (left: Self, right: Self) -> Self
  static func ./ (left: Self, right: Self) -> Self
  static func .< (left: Self, right: Self) -> MaskType
  static func .> (left: Self, right: Self) -> MaskType
  
  static func max(_ left: Self, _ right: Self) -> Self
  static func min(_ left: Self, _ right: Self) -> Self
}

infix operator ./: MultiplicationPrecedence
infix operator .*: MultiplicationPrecedence
