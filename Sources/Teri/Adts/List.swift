/// Lists
public indirect enum List<T: Term & Equatable>: Term {
  
  case empty
  case cons(T, List<T>)
  case insert(T, List<T>)
  case remove(T, List<T>)
  case concat(List<T>, List<T>)
  case contains(T, List<T>)
  case isEmpty(List<T>)
  case size(List<T>)
  case `var`(String)
  
  public func rewriting() -> Term? {
    switch self {
    case .insert(_, _):
      return self.ruleInsert()
    case .remove(_, _):
      return self.ruleRemove()
    case .concat(_, _):
      return self.ruleConcat()
    case .contains(_, _):
      return self.ruleContains()
    case .isEmpty(_):
      return self.ruleIsEmpty()
    case .size(_):
      return self.ruleSize()
    default:
      return nil
    }
  }
  
  public func ruleInsert() -> List<T>? {
    switch self {
    case .insert(let t, let list):
      return .cons(t, list)
    default:
      return nil
    }
  }
  
  public func ruleRemove() -> List<T>? {
    switch self {
    case .remove(_, .empty):
      return .empty
    case .remove(let t1, .cons(let t2, let l)):
      if t1 == t2 {
        return l
      } else {
        return .cons(t2, .remove(t1, l))
      }
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
  
  public func ruleContains() -> Term? {
    switch self {
    case .contains(_, .empty):
      return Boolean.false
    case .contains(let el1, .cons(let  el2, let l)):
      if el1 == el2 {
        return Boolean.true
      } else  {
        return List<T>.contains(el1, l)
      }
    default:
      return nil
    }
  }
  
  public func ruleIsEmpty() -> Boolean? {
    switch self {
    case .isEmpty(.empty):
      return .true
    case .isEmpty(.cons(_, _)):
      return .false
    default:
      return nil
    }
  }
  
  // Need to be improved: In this form, the application of the rule size on a list
  // needs to transform the entire list into a Nat, because of the rule Nat.add which only accepts Nat.
  // So, we cannot have a perfect step by step rewriting for this rule.
  func ruleSize() -> Nat? {
    switch self {
    case .size(.empty):
      return .zero
    case .size(.cons(_, let l)):
      if let n = List<T>.size(l).ruleSize() {
        return Nat.add(.succ(.zero), n)
      }
    default:
      return nil
    }
    return nil
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
    case .remove(let t, let l):
      if let tSubs = t.substitution(dicVal: dicVal) as? T,
        let lSubs = l.substitution(dicVal: dicVal) as? List<T> {
        return List<T>.remove(
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
    case .contains(let t, let l):
      if let tSubs = t.substitution(dicVal: dicVal) as? T,
        let lSubs = l.substitution(dicVal: dicVal) as? List<T> {
        return List<T>.contains(
          tSubs,
          lSubs
        )
      }
    case .isEmpty(let l):
      if let lSubs = l.substitution(dicVal: dicVal) as? List<T> {
        return List<T>.isEmpty(lSubs)
      }
    case .size(let l):
      if let lSubs = l.substitution(dicVal: dicVal) as? List<T> {
        return List<T>.size(lSubs)
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
    case .remove(let h, let l):
      if let hEval = Strategy.eval(t: h, s: s) as? T {
        if let lEval = Strategy.eval(t: l, s: s) as? List<T> {
          return List<T>.remove(hEval, lEval)
        }
      }
    case .concat(let l1, let l2):
      if let l1Eval = Strategy.eval(t: l1, s: s) as? List<T> {
        if let l2Eval = Strategy.eval(t: l2, s: s) as? List<T> {
          return List<T>.concat(l1Eval, l2Eval)
        }
      }
    case .contains(let h, let l):
      if let hEval = Strategy.eval(t: h, s: s) as? T {
        if let lEval = Strategy.eval(t: l, s: s) as? List<T> {
          return List<T>.contains(hEval, lEval)
        }
      }
    case .isEmpty(let l):
      if let lEval = Strategy.eval(t: l, s: s) as? List<T> {
        return List<T>.isEmpty(lEval)
      }
    case .size(let l):
      if let lEval = Strategy.eval(t: l, s: s) as? List<T> {
        return List<T>.size(lEval)
      }
    }
    return nil
  }
  
}
