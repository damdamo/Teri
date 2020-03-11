//
//  Strategy.swift
//  Teri
//
//  Created by Damien Morard on 06.02.20.
//

indirect enum Strategy {
  // Generators
  case identity
  case fail
  case axiom
  case sequence(Strategy, Strategy)
  case choice(Strategy, Strategy)
  case all(Strategy)
  // Bonus
  case `try`(Strategy)
  case `repeat`(Strategy)
  case bottomup(Strategy)
  case topdown(Strategy)
  case innermost(Strategy)
  
}

//struct Strat {
//
//
//
//}

//func fAxiom(_ t: Term) -> Term? {
//  switch t {
//  case .n(_):
//    return Nat.rewriting(t)
//  case .b(_):
//    return Boolean.rewriting(t)
//  }
//}
//
//func fSequence(_ t: Term, s1: Strategy, s2: Strategy) -> Term? {
//  if let t1 = eval(t: t, s: s1) {
//    if let t2 = eval(t: t1, s: s2) {
//      return t2
//    }
//  }
//  return nil
//}
//
//static func eval(t: Term, s: Strategy) -> Term? {
//  switch s {
//  case .identity:
//    return t
//  case .fail:
//    return nil
//  case .axiom:
//    return fAxiom(t)
//  case .sequence(let s1, let s2):
//    return fSequence(t, s1: s1, s2: s2)
//  default:
//    return nil
//  }
//
//}
