//
//  Term.swift
//  Teri
//
//  Created by Damien Morard on 25.10.19.
//

// Express the way to write Term with an Enum for Natural
indirect enum Nat {
  case zero
  case succ(Nat)
  case add(Nat, Nat)
  case `var`(String)
  
//  static func replace(_ nat: Nat) -> Nat {
//    return .zero
//  }
}

