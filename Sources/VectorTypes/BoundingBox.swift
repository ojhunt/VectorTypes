//
//  BoundingBox.swift
//  
//
//  Created by Oliver Hunt on 3/18/22.
//

@frozen public struct BoundingBox<PointType: Point> {
  typealias AxisType = PointType.AxisType
  
  @inline(__always) public let minBound: PointType;
  @inline(__always) public let maxBound: PointType;
  @inline(__always) public init() {
    minBound = PointType.max
    maxBound = PointType.min
  }
  
  @inline(__always) public init(min: PointType, max: PointType) {
    self.minBound = min
    self.maxBound = max
  }
  
  @inline(__always) public func maxAxis() -> PointType.AxisType {
    let range = maxBound - minBound;
    let cases = AxisType.allAxes
    let startIndex = cases.startIndex
    
    var max = cases[startIndex]
    var maxValue = range[max]
    for axis in cases {
      if range[axis] > maxValue {
        max = axis
        maxValue = range[axis]
      }
    }
    return max;
  }
  
  @inline(__always) public func merge(other: Self) -> Self {
    return BoundingBox(min: PointType.minElements(minBound, other.minBound), max: PointType.maxElements(maxBound, other.maxBound))
  }
  
  @inline(__always) public func merge(point: PointType) -> Self {
    return BoundingBox(min: PointType.minElements(minBound, point), max: PointType.maxElements(maxBound, point))
  }

  @inline(__always) public func centroid() -> PointType where PointType.VectorType : Vector {
    return minBound + (maxBound - minBound) / 2;
  }
  
  @inline(__always) public func surfaceArea() -> PointType.ValueType {
    let size = maxBound - minBound;
    var result = PointType.ValueType(exactly: 1)!
    for axis in PointType.AxisType.allAxes {
      result *= size[axis]
    }
    return result;
  }
  
  @inline(__always) public func offsetRatio(point: PointType, axis: PointType.AxisType) -> PointType.ValueType
  where PointType.ValueType: FloatingPoint {
    let o = point - minBound;
    let scaleFactor = maxBound[axis] - minBound[axis];
    return o[axis] / scaleFactor
  }
}

extension BoundingBox : Sendable where PointType : Sendable {
  
}

public protocol IntConvertibleFloatingPoint: FloatingPoint, ExpressibleByFloatLiteral {
  var asInteger: Int { get }
  init(_: Float)
  init(_: Double)
}

extension Float: IntConvertibleFloatingPoint {
  @inline(__always) public var asInteger: Int {
    return Int(self)
  }
}

extension Double: IntConvertibleFloatingPoint {
  @inline(__always) public var asInteger: Int {
    return Int(self)
  }
}

public protocol Ray {
  associatedtype PointType: Point
  typealias ValueType = PointType.ValueType
  var direction: PointType.VectorType { get }
  var origin: PointType { get }
}

public extension BoundingBox where PointType: Point, PointType.ValueType: IntConvertibleFloatingPoint, PointType.VectorType: Vector {
  @inline(__always) func offsetRatio(point: PointType, axis: PointType.AxisType) -> PointType.ValueType {
    let o = point - minBound;
    let scaleFactor = maxBound[axis] - minBound[axis];
    return o[axis] / scaleFactor
  }
  
  @inline(__always) func surfaceArea() -> PointType.ValueType {
    let size = maxBound - minBound;
    var result = PointType.ValueType(1.0)
    for axis in PointType.AxisType.allAxes {
      result *= size[axis]
    }
    return result;
  }

  @inline(__always) func intersect<RayType: Ray>(_ ray: RayType, min near: RayType.ValueType, max far: RayType.ValueType) -> (min: RayType.ValueType, max: RayType.ValueType)?
  where RayType.PointType == PointType {
    var tmin = PointType.VectorType(repeating: near);
    var tmax = PointType.VectorType(repeating: far);

    let direction = ray.direction;
    let origin = ray.origin;

    let inverseDir = PointType.VectorType(repeating: 1.0) ./ direction;
    let unnormalizedT1 = (minBound - origin) .* inverseDir;
    let unnormalizedT2 = (maxBound - origin) .* inverseDir;
    let compareMask = unnormalizedT1 .> unnormalizedT2;
    let t1 = unnormalizedT1.replace(with: unnormalizedT2, where: compareMask)
    let t2 = unnormalizedT2.replace(with: unnormalizedT1, where: compareMask);
    tmin = PointType.VectorType.max(tmin, t1);
    tmax = PointType.VectorType.min(tmax, t2);
    if (tmin .> tmax).any {
      return nil;
    }
    return (tmin.maxElement(), tmax.minElement() + 0.01);
  }
}
