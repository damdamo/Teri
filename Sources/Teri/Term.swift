///// Enum which groups all terms
///// Give methods to evaluate a term with strategies
/////  Terms available: Nat / Boolean
//public indirect enum Term {
//
//  case Nat
//  case Boolean
//
//  // Try to find an axiom to rewrite the term
//  func axiom() -> Term? {
//    switch self {
//    case let n as Nat:
//      return n.rewriting()
//    case let b as Boolean:
//      return b.rewriting()
////    case .list(let l):
////      return l.rewriting()
//    default:
//      return nil
//    }
//  }
//
//  // (s1)[t] = fail => (sequence(s1,s2))[t] = fail (where t is self)
//  // (s1)[t] = t' => (sequence(s1,s2))[t] = (s2)[t']
//  func sequence(s1: Strategy, s2: Strategy) -> Term? {
//    if let t1 = self.eval(s: s1) {
//      if let t2 = t1.eval(s: s2) {
//        return t2
//      }
//    }
//    return nil
//  }
//
//  // (s1)[t] = t' => (choice(s1,s2))[t] = t' (where t is self)
//  // (s1)[t] = fail => (choice(s1,s2))[t] = (s2)[t]
//  func choice(s1: Strategy, s2: Strategy) -> Term? {
//    if let t1 = self.eval(s: s1) {
//      return t1
//    } else if let t2 = self.eval(s: s2) {
//      return t2
//    }
//    return nil
//  }
//
//  // (s)[t1] = t1', ..., s[tn] = tn' => (All(s))[f(t1,...,tn)] = f(t1',...,tn')
//  // If there exists i, such that (s)[ti] = fail => (All(s))[f(t1,...,tn)] = fail
//  // (All(s))[cst] = cst
//  // Apply to the direct subterms the strategy s.
//  public func all(s: Strategy) -> Term? {
//    switch self {
//    case .n(let n):
//      return n.all(s: s)
//    case .b(let b):
//      return b.all(s: s)
//    default:
//      return nil
//    }
//  }
//
//  /// Evaluate a term using a given strategy
//  /// - Parameters:
//  ///   - s: The strategy to use
//  /// Returns: The result of the evaluate term with the given strategy
//  public func eval(s: Strategy) -> Term? {
//    switch s {
//    case .identity:
//      return self
//    case .fail:
//      return nil
//    case .axiom:
//      return self.axiom()
//    case .sequence(let s1, let s2):
//      return self.sequence(s1: s1, s2: s2)
//    case .choice(let s1, let s2):
//      return self.choice(s1: s1, s2: s2)
//    case .try(let s1):
//      return self.choice(s1: s1, s2: .identity)
//    case .all(let s1):
//      return self.all(s: s1)
//    case .innermost(let s1):
//      return self.eval(s: .sequence(.all(.innermost(s1)), .try(.sequence(s1, .innermost(s1)))))
//    case .outermost(let s1):
//      return self.eval(s: .sequence(.try(.sequence(s1, .outermost(s1))), .all(.outermost(s1))))
//    default:
//      return nil
//    }
//  }
//}
//
//extension Term: CustomStringConvertible {
//  public var description: String {
//    switch self {
//    case .n(let x):
//      return x.description
//    case .b(let b):
//      return b.description
//    default:
//      return ""
//    }
//  }
//}

public protocol Term {}
