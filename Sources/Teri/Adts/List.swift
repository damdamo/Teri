/// Lists
public indirect enum List<T: Term & Equatable>: Term {
  
  case empty
  case cons(T, List<T>)
  case insert(T, List<T>)
  case concat(List<T>, List<T>)
  case `var`(String)
  
  public func ruleInsert() -> List<T>? {
    switch self {
    case .insert(let t, let list):
      return .cons(t, list)
    default:
      return nil
    }
  }
  
  public func ruleConcat() -> List<T>? {
    switch self {
    case .concat(.empty, let list):
      return list
    case .concat(.cons(let t, let list1), let list2):
      return List<T>.concat(list1, .cons(t, list2)).ruleConcat()
    default:
      return nil
    }
  }
  
  public func rewriting() -> Term? {
    switch self {
    case .insert(_, _):
      return self.ruleInsert()
    case .concat(_, _):
      return self.ruleConcat()
    default:
      return nil
    }
  }
  
  public func substitution(dicVal: [String: Term]) -> Term? {
    switch self {
    case .empty:
      return List<T>.empty
    case .var(let x):
      if let s = dicVal[x] as? List<T> {
        return s
      } else if let s = dicVal[x] as? T {
        return s
      } else {
        return List<T>.var(x)
      }
    case .cons(let t, let l):
      if let tSubs = t.substitution(dicVal: dicVal) as? T,
        let lSubs = l.substitution(dicVal: dicVal) as? List<T> {
        return List<T>.cons(
          tSubs,
          lSubs
        )
      }
    case .insert(let t, let l):
      if let tSubs = t.substitution(dicVal: dicVal) as? T,
        let lSubs = l.substitution(dicVal: dicVal) as? List<T> {
        return List<T>.insert(
          tSubs,
          lSubs
        )
      }
    case .concat(let l1, let l2):
      if let l1Subs = l1.substitution(dicVal: dicVal) as? List<T>,
        let l2Subs = l2.substitution(dicVal: dicVal) as? List<T> {
        return List<T>.concat(
          l1Subs,
          l2Subs
        )
      }
    }
    return nil
  }
  
  public func all(s: Strategy) -> Term? {
    switch self {
    case .empty:
      return List<T>.empty
    case .var(let x):
      return List<T>.var(x)
    case .cons(let h, let l):
      if let hEval = Strategy.eval(t: h, s: s) as? T {
        if let lEval = Strategy.eval(t: l, s: s) as? List<T> {
          return List<T>.cons(hEval, lEval)
        }
      }
    case .insert(let h, let l):
      if let hEval = Strategy.eval(t: h, s: s) as? T {
        if let lEval = Strategy.eval(t: l, s: s) as? List<T> {
          return List<T>.insert(hEval, lEval)
        }
      }
    case .concat(let l1, let l2):
      if let l1Eval = Strategy.eval(t: l1, s: s) as? List<T> {
        if let l2Eval = Strategy.eval(t: l2, s: s) as? List<T> {
          return List<T>.concat(l1Eval, l2Eval)
        }
      }
    }
    return nil
  }
  
}
