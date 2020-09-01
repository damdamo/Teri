/// Description of Naturals
public indirect enum Nat: Term, Equatable {
  case zero
  case succ(Nat)
  case add(Nat, Nat)
  case sub(Nat, Nat)
  case eq(Nat, Nat)
  case `var`(String)
  
  public func rewriting() -> Term? {
    switch self {
    case .add(_, _):
      return self.ruleAdd()
    case .sub(_, _):
      return self.ruleSub()
    case .eq(_, _):
      return self.ruleEq()
    default:
      return nil
    }
  }
  
  public func ruleAdd() -> Nat? {
    switch self {
    case .add(let a, .zero):
      return a
    case .add(let a, .succ(let b)):
      return .succ(.add(a, b))
    default:
      return nil
    }
  }
  
  public func ruleSub() -> Nat? {
    switch self {
    case .sub(.zero, _):
      return .zero
    case .sub(let a, .zero):
      return a
    case .sub(.succ(let a), .succ(let b)):
      return .sub(a,b)
    default:
      return nil
    }
  }

  public func ruleEq() -> Boolean? {
    switch self {
    case .eq(let x, let y):
      if x == y {
        return .true
      } else {
        return .false
      }
    default:
      return nil
    }
  }
  
  public func substitution(dicVal: [String: Nat]) -> Nat {
    switch self {
    case .zero:
      return .zero
    case .var(let x):
      if let s = dicVal[x] {
        return s
      } else {
        return .var(x)
      }
    case .succ(let x):
      return .succ(x.substitution(dicVal: dicVal))
    case .add(let x, let y):
      return .add(
        x.substitution(dicVal: dicVal),
        y.substitution(dicVal: dicVal)
      )
    case .sub(let x, let y):
      return .add(
        x.substitution(dicVal: dicVal),
        y.substitution(dicVal: dicVal)
      )
    case .eq(let x, let y):
      return .eq(
        x.substitution(dicVal: dicVal),
        y.substitution(dicVal: dicVal)
      )
    }
  }
  
  public func all(s: Strategy) -> Term? {
    switch self {
    case .zero:
      return Nat.zero
    case .var(let x):
      return Nat.var(x)
    case .succ(let x):
      if let xEval = Strategy.eval(t: x, s: s) as? Nat {
        return Nat.succ(xEval)
      }
    case .add(let x, let y):
      if let xEval = Strategy.eval(t: x, s: s) as? Nat {
        if let yEval = Strategy.eval(t: y, s: s) as? Nat {
          return Nat.add(xEval, yEval)
        }
      }
    case .sub(let x, let y):
      if let xEval = Strategy.eval(t: x, s: s) as? Nat {
        if let yEval = Strategy.eval(t: y, s: s) as? Nat {
          return Nat.sub(xEval, yEval)
        }
      }
      
    case .eq(let x, let y):
      if let xEval = Strategy.eval(t: x, s: s) as? Nat {
        if let yEval = Strategy.eval(t: y, s: s) as? Nat {
          return Nat.eq(xEval, yEval)
        }
      }
    }
    return nil
  }
}
