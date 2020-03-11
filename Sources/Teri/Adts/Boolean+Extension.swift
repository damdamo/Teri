//
//  Nat+Extension.swift
//  Teri
//
//  Created by Damien Morard on 05.02.20.
//

extension Boolean: Hashable {
    
  static func == (lhs: Boolean, rhs: Boolean) -> Bool {
    var lhsAnonymized: [String: String] = [:]
    var rhsAnonymized: [String: String] =  [:]
    return Boolean.equals(lhs: lhs, rhs: rhs, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
  }
  
  /// Compare two terms where we do not care about the variable names. For example x + y == a + b --> true
  /// To anonymise variables, we replace its by a string number. For instance: x + y becomes "0" + "1"
  /// So, x + y == a + b becomes "0" + "1" == "0" + "1" which is true
  ///
  /// - Parameters:
  ///   - lhs: Left term to compare
  ///   - rhs: Right term to compare
  ///   - lhsAnonymized: A dictionary which contains left variables with its corresponding string number
  ///   - rhsAnonymized: A dictionary which contains right variables with its corresponding string number
  /// Returns: A boolean which is true if the both term are the same
  static func equals(lhs: Boolean, rhs: Boolean, lhsAnonymized: inout [String: String], rhsAnonymized: inout [String:String]) -> Bool {
    switch (lhs, rhs) {
    case (.true, .true):
      return true
    case (.false, .false):
      return true
    case (.var(let s1), .var(let s2)):
      let nbVarLhs = lhsAnonymized.count
      let nbVarRhs = rhsAnonymized.count
    
      if lhsAnonymized[s1] == nil {
        lhsAnonymized[s1] = "\(nbVarLhs)"
      }
      if rhsAnonymized[s2] == nil {
        rhsAnonymized[s2] = "\(nbVarRhs)"
      }
      return lhsAnonymized[s1] == rhsAnonymized[s2]
    case (.not(let x), .not(let y)):
      return equals(lhs: x, rhs: y, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
    case (.and(let x1, let y1), .and(let x2, let y2)):
      return (
        equals(lhs: x1, rhs: x2, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized) &&
        equals(lhs: y1, rhs: y2, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
      )
    case (.or(let x1, let y1), .or(let x2, let y2)):
      return (
        equals(lhs: x1, rhs: x2, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized) &&
        equals(lhs: y1, rhs: y2, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
      )
    default:
      return false
    }
  }

  func hash(into hasher: inout Hasher) {
    switch self {
    case .true:
      hasher.combine("true")
    case .false:
      hasher.combine("false")
    case .var(let x):
      hasher.combine(x)
    case .not(let x):
      hasher.combine("not")
      hasher.combine(x.hashValue)
    case .and(let x, let y):
      hasher.combine("and")
      hasher.combine(x.hashValue)
      hasher.combine(y.hashValue)
    case .or(let x, let y):
      hasher.combine("or")
      hasher.combine(x.hashValue)
      hasher.combine(y.hashValue)
    }
  }
  
}


extension Boolean: CustomStringConvertible {
  var description: String {
    switch self {
    case .true:
      return "true"
    case .false:
      return "false"
    case .not(let x):
      return "not(\(x.description))"
    case .and(let x, let y):
      return "\(x.description) ∧ \(y.description)"
    case .or(let x, let y):
      return "(\(x.description) ∨ \(y.description))"
    case .var(let v):
      return v
    }
  }
}
