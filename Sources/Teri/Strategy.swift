/// Enum of the different strategies:
/// Generators: identity / fail / axiom / sequence / choice / all
/// Bonus: try / repeat / bottomup / topdown / innermost
public indirect enum Strategy {
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
  case outermost(Strategy)
  
  // Try to find an axiom to rewrite the term
  static func axiom(t: Term) -> Term? {
    switch t {
    case let n as Nat:
      return n.rewriting()
    case let b as Boolean:
      return b.rewriting()
//    case .list(let l):
//      return l.rewriting()
    default:
      return nil
    }
  }

  // (s1)[t] = fail => (sequence(s1,s2))[t] = fail (where t is self)
  // (s1)[t] = t' => (sequence(s1,s2))[t] = (s2)[t']
  static func sequence(t: Term, s1: Strategy, s2: Strategy) -> Term? {
    if let t1 = eval(t: t, s: s1) {
      if let t2 = eval(t: t1, s: s2) {
        return t2
      }
    }
    return nil
  }

  // (s1)[t] = t' => (choice(s1,s2))[t] = t' (where t is self)
  // (s1)[t] = fail => (choice(s1,s2))[t] = (s2)[t]
  static func choice(t: Term, s1: Strategy, s2: Strategy) -> Term? {
    if let t1 = eval(t:t, s: s1) {
      return t1
    } else if let t2 = eval(t: t, s: s2) {
      return t2
    }
    return nil
  }

  // (s)[t1] = t1', ..., s[tn] = tn' => (All(s))[f(t1,...,tn)] = f(t1',...,tn')
  // If there exists i, such that (s)[ti] = fail => (All(s))[f(t1,...,tn)] = fail
  // (All(s))[cst] = cst
  // Apply to the direct subterms the strategy s.
  static public func all(t: Term, s: Strategy) -> Term? {
    switch t {
    case let n as Nat:
      return n.all(t: t as! Nat, s: s)
    case let b as Boolean:
      return b.all(t: t as! Boolean, s: s)
    default:
      return nil
    }
  }

  /// Evaluate a term using a given strategy
  /// - Parameters:
  ///   - s: The strategy to use
  /// Returns: The result of the evaluate term with the given strategy
  static public func eval(t: Term, s: Strategy) -> Term? {
    switch s {
    case .identity:
      return t
    case .fail:
      return nil
    case .axiom:
      return axiom(t: t)
    case .sequence(let s1, let s2):
      return sequence(t: t, s1: s1, s2: s2)
    case .choice(let s1, let s2):
      return choice(t: t, s1: s1, s2: s2)
    case .try(let s1):
      return choice(t: t, s1: s1, s2: .identity)
    case .all(let s1):
      return all(t: t, s: s1)
    case .innermost(let s1):
      return self.eval(t: t, s: .sequence(.all(.innermost(s1)), .try(.sequence(s1, .innermost(s1)))))
    case .outermost(let s1):
      return self.eval(t: t, s: .sequence(.try(.sequence(s1, .outermost(s1))), .all(.outermost(s1))))
    default:
      return nil
    }
  }


}
