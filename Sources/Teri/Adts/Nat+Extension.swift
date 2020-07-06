//
//  Nat+Extension.swift
//  Teri
//
//  Created by Damien Morard on 05.02.20.
//

extension Nat: Hashable {
    
//  static func == (lhs: Nat, rhs: Nat) -> Bool {
//    var lhsAnonymized: [String: String] = [:]
//    var rhsAnonymized: [String: String] =  [:]
//    return Nat.equals(lhs: lhs, rhs: rhs, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
//  }
//
//  /// Compare two terms where we do not care about the variable names. For example x + y == a + b --> true
//  /// To anonymise variables, we replace its by a string number. For instance: x + y becomes "0" + "1"
//  /// So, x + y == a + b becomes "0" + "1" == "0" + "1" which is true
//  ///
//  /// - Parameters:
//  ///   - lhs: Left term to compare
//  ///   - rhs: Right term to compare
//  ///   - lhsAnonymized: A dictionary which contains left variables with its corresponding string number
//  ///   - rhsAnonymized: A dictionary which contains right variables with its corresponding string number
//  /// Returns: A boolean which is true if the both term are the same
//  static func equals(lhs: Nat, rhs: Nat, lhsAnonymized: inout [String: String], rhsAnonymized: inout [String:String]) -> Bool {
//    switch (lhs, rhs) {
//    case (.zero, .zero):
//      return true
//    case (.var(let s1), .var(let s2)):
//      let nbVarLhs = lhsAnonymized.count
//      let nbVarRhs = rhsAnonymized.count
//
//      if lhsAnonymized[s1] == nil {
//        lhsAnonymized[s1] = "\(nbVarLhs)"
//      }
//      if rhsAnonymized[s2] == nil {
//        rhsAnonymized[s2] = "\(nbVarRhs)"
//      }
//      return lhsAnonymized[s1] == rhsAnonymized[s2]
//    case (.succ(let x), .succ(let y)):
//      return equals(lhs: x, rhs: y, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
//    case (.add(let x1, let y1), .add(let x2, let y2)):
//      return (
//        equals(lhs: x1, rhs: x2, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized) &&
//        equals(lhs: y1, rhs: y2, lhsAnonymized: &lhsAnonymized, rhsAnonymized: &rhsAnonymized)
//      )
//    default:
//      return false
//    }
//  }
  
  /// Anonymized variables in a term by a simple string number
  /// For instance, x + y becomes "0" + "1".
  /// It can be used to compare two differents terms with different variables names
  /// - Parameters:
  ///   - term: The term to anonymize
  ///   - varAnonymized: A dictionary which contains variables with its corresponding string number
  /// Returns: The anonymized term
  func anonymizedRec(varAnonymized: inout [String:String]) -> Nat {
    switch self {
    case .zero:
      return .zero
    case .var(let t):
      let nbVarTerm = varAnonymized.count
      if varAnonymized[t] == nil {
        varAnonymized[t] = "\(nbVarTerm)"
      }
      return .var(varAnonymized[t]!)
    case .succ(let t):
      return .succ(t.anonymizedRec(varAnonymized: &varAnonymized))
    case .add(let t1, let t2):
      return .add(t1.anonymizedRec(varAnonymized: &varAnonymized), t2.anonymizedRec(varAnonymized: &varAnonymized))
    case .sub(let t1, let t2):
      return .sub(t1.anonymizedRec(varAnonymized: &varAnonymized), t2.anonymizedRec(varAnonymized: &varAnonymized))
    case .eq(let t1, let t2):
      return .eq(t1.anonymizedRec(varAnonymized: &varAnonymized), t2.anonymizedRec(varAnonymized: &varAnonymized))
    }
  }
  
  func anonymized() -> Nat {
    var varAnonymized: [String:String] = [:]
    return self.anonymizedRec(varAnonymized: &varAnonymized)
  }

  func hash(into hasher: inout Hasher) {
    switch self {
    case .zero:
      hasher.combine(0)
    case .var(let x):
      hasher.combine(x)
    case .succ(let x):
      hasher.combine("succ")
      hasher.combine(x.hashValue)
    case .add(let x, let y):
      hasher.combine("add")
      hasher.combine(x.hashValue)
      hasher.combine(y.hashValue)
    case .sub(let x, let y):
      hasher.combine("sub")
      hasher.combine(x.hashValue)
      hasher.combine(y.hashValue)
    case .eq(let x, let y):
      hasher.combine("eq")
      hasher.combine(x.hashValue)
      hasher.combine(y.hashValue)
    }
  }
  
}


extension Nat: CustomStringConvertible {
  var description: String {
    switch self {
    case .zero:
      return "0"
    case .succ(let x):
      return "succ(\(x.description))"
    case .eq(let x, let y):
      return "\(x.description) == \(y.description)"
    case .add(let x, let y):
      return "add(\(x.description), \(y.description))"
    case .sub(let x, let y):
      return "sub(\(x.description), \(y.description))"
    case .var(let v):
      return v
    }
  }
}
