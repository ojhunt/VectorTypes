//
//  Point.swift
//  
//
//  Created by Oliver Hunt on 3/19/22.
//

public protocol Point: Equatable {
  associatedtype AxisType: IterableAxis
  associatedtype ValueType where VectorType.ValueType == ValueType
  associatedtype VectorType: IndexableVector where
                 VectorType.AxisType == AxisType
  associatedtype MaskType: Mask
  
  static var min: Self { get };
  static var max: Self { get };
  static func minElements(_ left: Self, _ right: Self) -> Self;
  static func maxElements(_ left: Self, _ right: Self) -> Self;

  subscript(_ axis: AxisType) -> ValueType { get }
  
  static func - (left: Self, right: Self) -> VectorType
  
  static func + (left: Self, right: VectorType) -> Self
  static func - (left: Self, right: VectorType) -> Self
  
  static func .< (left: Self, right: Self) -> MaskType
  static func .> (left: Self, right: Self) -> MaskType
}

public extension Point where AxisType: CaseIterable {
  typealias AllAxes = AxisType.AllCases
  static var allAxes: AllAxes { AxisType.allCases }
}
