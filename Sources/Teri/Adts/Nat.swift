/// Description of Naturals
public indirect enum Nat: Term, Equatable {
  case zero
  case succ(Nat)
  case add(Nat, Nat)
  case sub(Nat, Nat)
  case mul(Nat, Nat)
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
    case .mul(_, _):
      return self.ruleMul()
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
  
  public func ruleMul() -> Nat? {
    switch self {
    case .mul(.zero, _):
      return .zero
    case .mul(_, .zero):
      return .zero
    case .mul(let x, .succ(.zero)):
      return x
    case .mul(let x, .succ(let y)):
      return .add(x, .mul(x, y))
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
  
  public func substitution(dicVal: [String: Term]) -> Term? {
    switch self {
    case .zero:
      return Nat.zero
    case .var(let x):
      if let s = dicVal[x] {
        return s
      } else {
        return Nat.var(x)
      }
    case .succ(let x):
      if let xSubs = x.substitution(dicVal: dicVal) as? Nat {
        return Nat.succ(xSubs)
      }
    case .add(let x, let y):
      if let xSubs = x.substitution(dicVal: dicVal) as? Nat,
        let ySubs = y.substitution(dicVal: dicVal) as? Nat {
        return Nat.add(
          xSubs,
          ySubs
        )
      }
    case .sub(let x, let y):
      if let xSubs = x.substitution(dicVal: dicVal) as? Nat,
        let ySubs = y.substitution(dicVal: dicVal) as? Nat {
        return Nat.sub(
          xSubs,
          ySubs
        )
      }
    case .mul(let x, let y):
      if let xSubs = x.substitution(dicVal: dicVal) as? Nat,
        let ySubs = y.substitution(dicVal: dicVal) as? Nat {
        return Nat.mul(
          xSubs,
          ySubs
        )
      }
    case .eq(let x, let y):
      if let xSubs = x.substitution(dicVal: dicVal) as? Nat,
        let ySubs = y.substitution(dicVal: dicVal) as? Nat {
        return Nat.eq(
          xSubs,
          ySubs
        )
      }
    }
    return nil
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
    case .mul(let x, let y):
      if let xEval = Strategy.eval(t: x, s: s) as? Nat {
        if let yEval = Strategy.eval(t: y, s: s) as? Nat {
          return Nat.mul(xEval, yEval)
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
