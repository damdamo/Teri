//
//  Nat+Evaluate.swift
//  Teri
//
//  Created by Damien Morard on 06.02.20.
//

//extension Nat {
//
//  static func evaluate(_ t: Nat, strategy: Strategy) -> Term? {
//    switch strategy {
////    case .leftRightOuterMost:
////      return evaluateLeftRightOuterMost(t)
//    case .leftRightInnerMost:
//      return evaluateLeftRightInnerMost(t)
//    }
//  }
//
//  // Strategy Innermost
//  static func evaluateLeftRightInnerMost(_ t: Nat) -> Term? {
//    switch t {
//    case .eq(let x, let y):
//      return .b(equal(evaluateNatInnerMost(x)!, evaluateNatInnerMost(y)!))
//    default:
//      return .n(evaluateNatInnerMost(t)!)
//    }
//  }
//
//  static func evaluateNatInnerMost(_ t: Nat) -> Nat? {
//    switch t {
//    case .zero:
//      return .zero
//    case .succ(let x):
//      return .succ(evaluateNatInnerMost(x)!)
//    case .add(let x, let y):
//      return addition(evaluateNatInnerMost(x)!, evaluateNatInnerMost(y)!)
//    case .sub(let x, let y):
//      return subtraction(evaluateNatInnerMost(x)!, evaluateNatInnerMost(y)!)
//    case .var(let v):
//      return .var(v)
//    default:
//      return nil
//    }
//  }
  
  // Strategy Outermost
  
//  static func evaluateLeftRightOuterMost(_ t: Nat) -> Term? {
//    switch t {
//    case .eq(let x, let y):
//      return .b(equal(evaluateNatOuterMost(x), evaluateNatOuterMost(y)))
//    default:
//      return .n(evaluateNatOuterMost(t))
//    }
//  }
  
//  static func evaluateNatOuterMost(_ t: Nat) -> Nat {
//    var st: Nat
//    switch t {
//    case .zero:
//      return .zero
//    case .succ(let x):
//      return .succ(evaluateNatOuterMost(x))
//    case .add(let x, let y):
//      st = addition(x, y)
//      return evaluateNatOuterMost(st)
//    case .sub(let x, let y):
//      st = subtraction(x, y)
//      return evaluateNatOuterMost(st)
//    case .var(let v):
//      return .var(v)
//    default:
//      fatalError()
//    }
//  }
//
//}
