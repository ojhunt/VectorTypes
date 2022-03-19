//
//  File.swift
//  
//
//  Created by Oliver Hunt on 3/19/22.
//

import Foundation

public protocol Vector : IndexableVector {
  associatedtype AxisType
  associatedtype MaskType
  
  subscript(_ axis: AxisType) -> Float { get }
  init(splat: Float)
  func length() -> Float
  func replace(with other: Self, where c: MaskType) -> Self
  func minElement() -> Float
  func maxElement() -> Float
  
  static func random() -> Self
  static func random(_ radius: Float) -> Self
  static func - (left: Self, right: Self) -> Self
  static func + (left: Self, right: Self) -> Self
  static func * (left: Self, right: Float) -> Self
  static func * (left: Float, right: Self) -> Self
  static func / (left: Self, right: Float) -> Self
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
