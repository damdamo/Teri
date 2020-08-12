/// Description of Naturals
public indirect enum Nat: PTerm {
  case zero
  case succ(Nat)
  case add(Nat, Nat)
  case sub(Nat, Nat)
  case eq(Nat, Nat)
  case `var`(String)
  
  public func rewriting() -> Term? {
    switch self {
    case .add(let x, let y):
      if let r = x.addition(y) {
        return .n(r)
      }
    case .sub(let x, let y):
      if let r = x.subtraction(y) {
        return .n(r)
      }
    case .eq(let x, let y):
      if let r = x.equal(y) {
        return .b(r)
      }
    default:
      return nil
    }
    return nil
  }
  
  public func all(s: Strategy) -> Term? {
    switch self {
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
  }
  
  func addition(_ x: Nat) -> Nat? {
    switch (self,x) {
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
  
  func subtraction(_ x: Nat) -> Nat? {
    switch(self,x) {
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

  func equal(_ x: Nat) -> Boolean? {
    if self == x {
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
