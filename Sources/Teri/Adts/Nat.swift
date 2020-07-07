/// Description of Naturals
indirect enum Nat: Equatable {
  
  case zero
  case succ(Nat)
  case add(Nat, Nat)
  case sub(Nat, Nat)
  case eq(Nat, Nat)
  case `var`(String)
  
  static func rewriting(_ t: Term) -> Term? {
    switch t {
    case .n(let st):
      switch st {
//      case .zero:
//        return .n(.zero)
//      case .succ(let x):
//        return .n(.succ(x))
//      case .var(let x):
//        return .n(.var(x))
      case .add(let x, let y):
        if let r = addition(x, y) {
          return .n(r)
        }
      case .sub(let x, let y):
        if let r = subtraction(x, y) {
          return .n(r)
        }
      case .eq(let x, let y):
        if let r = equal(x, y) {
          return .b(r)
        }
      default:
        return nil
      }
    default:
      return nil
    }
    return nil
  }
  
  static func all(t: Term, s: Strategy) -> Term? {
    switch t {
    case .n(let n):
      switch n {
      case .zero:
        return .n(.zero)
      
      case .var(let x):
        return .n(.var(x))
        
      case .succ(let x):
        let t1 = Term.n(x).eval(s: s)
        switch t1 {
        case .n(let x1):
          return .n(.succ(x1))
        default:
          return nil
        }
      
      case .add(let x, let y):
        let t1 = Term.n(x).eval(s: s)
        let t2 = Term.n(y).eval(s: s)
        switch (t1, t2) {
        case (.n(let x1), .n(let x2)):
          return .n(.add(x1,x2))
          
        default:
          return nil
        }
        
      case .sub(let x, let y):
        let t1 = Term.n(x).eval(s: s)
        let t2 = Term.n(y).eval(s: s)
        switch (t1, t2) {
        case (.n(let x1), .n(let x2)):
          return .n(.sub(x1,x2))
          
        default:
          return nil
        }
        
      case .eq(let x, let y):
        let t1 = Term.n(x).eval(s: s)
        let t2 = Term.n(y).eval(s: s)
        switch (t1, t2) {
        case (.n(let x1), .n(let x2)):
          return .n(.eq(x1,x2))
          
        default:
          return nil
        }
      }
    default:
      return nil
    }
  }
  
  static func addition(_ x: Nat, _ y: Nat) -> Nat? {
    switch (x,y) {
    case (let a, .zero):
      return a
    case (let a, .succ(let b)):
      return .succ(.add(a, b))
//    case (let a, let b):
//      return .add(a,b)
    default:
      return nil
    }
  }
  
  static func subtraction(_ x: Nat, _ y: Nat) -> Nat? {
    switch(x,y) {
    case (.zero, _):
      return .zero
    case (let a, .zero):
      return a
    case (.succ(let a), .succ(let b)):
      return .sub(a,b)
    default:
      return nil
//    case (let a, let b):
//      return.sub(a,b)
    }
  }

  static func equal(_ x: Nat, _ y: Nat) -> Boolean? {
    if x == y {
      return .true
    } else {
      return .false
    }
  }
  
  static func replace(t: Nat, substitution: [String: Nat]) -> Nat {
    switch t {
    case .zero:
      return .zero
    case .var(let x):
      if let s = substitution[x] {
        return s
      } else {
        return .var(x)
      }
    case .succ(let x):
      return .succ(replace(t: x, substitution: substitution))
    case .add(let x, let y):
      return .add(
        replace(t: x, substitution: substitution),
        replace(t: y, substitution: substitution))
    case .sub(let x, let y):
      return .add(
        replace(t: x, substitution: substitution),
        replace(t: y, substitution: substitution))
    case .eq(let x, let y):
      return .eq(
        replace(t: x, substitution: substitution),
        replace(t: y, substitution: substitution))
    }
  }
    
}


//enum RuleName {
//  case add
//  case sub
//  case eq
//}
//
///// Apply a declared rule on a term.
///// - Parameters:
/////   - t: The term where the rule is applied
/////   - ruleName: The rule to apply. Rule is a String.
///// - Returns: A new term where we try to apply the rule.
/////   If no rules are found, the term is just returned.
//func rewritingStep(t: Term, ruleName: RuleName) -> Term {
//  // st is a sub term
//  switch t {
//  case .n(let st):
//    switch ruleName {
//    case .add:
//      switch st {
//      case .add(let x, let y):
//        return .n(addition(x, y))
//      default:
//        return .n(st)
//      }
//    case .sub:
//      switch st {
//      case .sub(let x, let y):
//        return .n(subtraction(x, y))
//      default:
//        return .n(st)
//      }
//    case .eq:
//      switch st {
//      case .eq(let x, let y):
//        return .b(equal(x, y))
//      default:
//        return .n(st)
//      }
//    }
//  default:
//    return t
//  }
//}
