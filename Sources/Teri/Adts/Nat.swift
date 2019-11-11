//
//  Term.swift
//  Teri
//
//  Created by Damien Morard on 25.10.19.
//

// Express the way to write Term with an Enum for Natural
indirect enum Nat: Adt {
  case zero
  case succ(Nat)
  case add(Nat, Nat)
  case `var`(String)
  
  static func replace(_ term: Nat, subsTable: [String: Nat]) -> Nat {
    switch term {
    case .zero:
      return .zero
    case .succ(let x):
      return .succ(replace(x, subsTable: subsTable))
    case .add(let x, let y):
      return .add(replace(x, subsTable: subsTable), replace(y, subsTable: subsTable))
    case .var(let s):
      if let v = subsTable[s] {
        return v
      } else {
        return .var(s)
      }
    }
  }
  
  func eval() -> Nat {
    switch self {
    case .zero:
      return .zero
    case .succ(let x):
      return .succ(x.eval())
    case .var(let s):
      return .var(s)
    case .add(let x, let y):
      return _add(x.eval(),y.eval())
    }
  }
  
  // Add function
  private func _add(_ term1: Nat, _ term2: Nat) -> Nat {
    switch (term1, term2) {
    // 0 + y -> y
    case (.zero, let y):
      return y.eval()
    // s(x) + y -> x + s(y)
    case (.succ(let x), let y):
      return _add(x, .succ(y))
   // Otherwise
    default:
      return .add(term1, term2)
    }
  }
}

