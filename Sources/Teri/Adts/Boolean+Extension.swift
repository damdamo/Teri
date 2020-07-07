//
//  Nat+Extension.swift
//  Teri
//
//  Created by Damien Morard on 05.02.20.
//

extension Boolean: Hashable {

  func anonymizedRec(varAnonymized: inout [String:String]) -> Boolean {
    switch self {
    case .true:
      return .true
    case .false:
      return .false
    case .var(let t):
      let nbVarTerm = varAnonymized.count
      if varAnonymized[t] == nil {
        varAnonymized[t] = "\(nbVarTerm)"
      }
      return .var(varAnonymized[t]!)
    case .not(let t):
      return  .not(t.anonymizedRec(varAnonymized: &varAnonymized))
    case .and(let t1, let t2):
      return .and(t1.anonymizedRec(varAnonymized: &varAnonymized), t2.anonymizedRec(varAnonymized: &varAnonymized))
    case .or(let t1, let t2):
      return .or(t1.anonymizedRec(varAnonymized: &varAnonymized), t2.anonymizedRec(varAnonymized: &varAnonymized))
    }
  }

  func anonymized() -> Boolean {
    var varAnonymized: [String:String] = [:]
    return self.anonymizedRec(varAnonymized: &varAnonymized)
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
