//
//  Vector.swift
//  
//
//  Created by Oliver Hunt on 3/18/22.
//

public protocol IndexableVector {
  associatedtype AxisType
  associatedtype ValueType: Numeric & Comparable

  subscript(_ axis: AxisType) -> ValueType { get }
  init(repeating: ValueType)
  func squaredLength() -> ValueType
}

public extension IndexableVector where AxisType: IterableAxis {
  @inlinable @inline(__always) func squaredLength() -> ValueType {
    var result : ValueType = ValueType.zero
    for axis in AxisType.allAxes {
      let value = self[axis]
      result += value * value
    }
    return result
  }
}

