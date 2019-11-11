//
//  Boolean+Extension.swift
//  Teri
//
//  Created by Damien Morard on 31.10.19.
//

extension Boolean: Hashable {
  static func == (lhs: Boolean, rhs: Boolean) -> Bool {
    var lhsAnonymized: [String: String] = [:]
    var rhsAnonymized: [String: String] =  [:]
    return Boolean.equals(lhs: lhs, rhs: rhs, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
  }
  
  /// Compare two terms where we do not care about the variable names. For example and(b1, b2) == and(b3, b4) --> true
  /// To anonymise variables, we replace its by a string number. For instance: and(b1, b2) becomes and("0", "1")
  /// So, and(b1, b2) == and(b3, b4) becomes and("0", "1") == and("0", "1") which is true
  ///
  /// - Parameters:
  ///   - lhs: Left term to compare
  ///   - rhs: Right term to compare
  ///   - lhsAnonymized: A dictionary which contains left variables with its corresponding string number
  ///   - rhsAnonymized: A dictionary which contains right variables with its corresponding string number
  /// - sReturns: A boolean which is true if the both term are the same
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
    case (.not(let b1), .not(let b2)):
      return equals(lhs: b1, rhs: b2, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
    case (.and(let b1, let b2), .and(let b3, let b4)):
      return (
        equals(lhs: b1, rhs: b3, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized) &&
        equals(lhs: b2, rhs: b4, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
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
      hasher.combine("true")
    case .var(let s):
      hasher.combine(s)
    case .not(let b):
      hasher.combine("not")
      hasher.combine(b.hashValue)
    case .and(let b1, let b2):
      hasher.combine("and")
      hasher.combine(b1.hashValue)
      hasher.combine(b2.hashValue)
    }
  }

}

// Pretty print for Boolean
extension Boolean: CustomStringConvertible {
  var description: String {
    switch self {
    case .true:
      return "true"
    case .false:
      return "false"
    case .var(let s):
      return "\"\(s)\""
    case .not(let b):
      return "not(\(b.description))"
    case .and(let b1, let b2):
      return "and(\(b1.description), \(b2.description))"
    }
  }
}
