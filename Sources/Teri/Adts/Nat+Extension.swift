//
//  Nat+Extension.swift
//  Teri
//
//  Created by Damien Morard on 05.02.20.
//

extension Nat: Hashable {
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
