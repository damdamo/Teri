//
//  Boolean.swift
//  Teri
//
//  Created by Damien Morard on 31.10.19.
//

indirect enum Boolean: Adt {
  case `true`
  case `false`
  case not(Boolean)
  case and(Boolean, Boolean)
  case `var`(String)
  
  static func replace(_ term: Boolean, subsTable: [String: Boolean]) -> Boolean {
    switch term {
    case .true:
      return .true
    case .false:
      return .false
    case .not(let b):
      return .not(replace(b, subsTable: subsTable))
    case .and(let b1, let b2):
      return .and(replace(b1, subsTable: subsTable), replace(b2, subsTable: subsTable))
    case .var(let s):
      if let v = subsTable[s] {
        return v
      } else {
        return .var(s)
      }
    }
  }
  
  func eval() -> Boolean {
    switch self {
    case .true:
      return .true
    case .false:
      return .false
    case .var(let s):
      return .var(s)
    case .not(let b):
      return _not(b.eval())
    case .and(let b1, let b2):
      return _and(b1.eval(), b2.eval())

    }
  }
  
  private func _not(_ term: Boolean) -> Boolean {
    switch term {
    case .true:
      return .false
    case . false:
      return .true
    default:
      return .not(term.eval())
    }
  }
  
  private func _and(_ term1: Boolean, _ term2: Boolean) -> Boolean {
    switch (term1, term2) {
    // false ∧ _ -> false
    case (.false, _):
      return .false
    // _ ∧ false -> false
    case (_, .false):
      return .false
    // true ∧ true -> true
    case (.true, .true):
      return .true
    default:
      return .and(term1, term2)
    }
  }

}
