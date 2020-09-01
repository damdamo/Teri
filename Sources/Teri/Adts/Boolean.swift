/// Description of Booleans
public indirect enum Boolean: Term, Equatable {
  case `true`
  case `false`
  case not(Boolean)
  case or(Boolean, Boolean)
  case and(Boolean, Boolean)
  case `var`(String)
  
  public func rewriting() -> Term? {
    switch self {
    case .not(_):
      return self.ruleNot()
    case .and(_, _):
      return self.ruleAnd()
    case .or(_, _):
      return self.ruleOr()
    default:
      return nil
    }
  }
  
  public func ruleNot() -> Boolean? {
    switch self {
    case .not(.false):
      return .true
    case .not(.true):
      return .false
    case .not(.not(let b)):
      return b
    default:
      return nil
    }
  }

  func ruleOr() -> Boolean? {
    switch self {
    case .or(.true, _):
      return .true
    case .or(_,.true):
      return .true
    case .or(.false, .false):
      return .false
    default:
      return nil
    }
  }
  
  func ruleAnd() -> Boolean? {
    switch self {
    case .and(.false, _):
      return .false
    case .and(_,.false):
      return .false
    case .and(.true, .true):
      return .true
    default:
      return nil
    }
  }
  
  public func substitution(dicVal: [String: Boolean]) -> Boolean {
    switch self {
    case .true:
      return .true
    case .false:
      return .false
    case .var(let x):
      if let s = dicVal[x] {
        return s
      } else {
        return .var(x)
      }
    case .not(let x):
      return .not(x.substitution(dicVal: dicVal))
    case .and(let x, let y):
      return .and(
        x.substitution(dicVal: dicVal),
        y.substitution(dicVal: dicVal)
      )
    case .or(let x, let y):
      return .or(
        x.substitution(dicVal: dicVal),
        y.substitution(dicVal: dicVal)
      )
    }
  }
  
  public func all(s: Strategy) -> Term? {
    switch self {
    case .true:
      return Boolean.true
    case .false:
      return Boolean.false
    case .var(let b):
      return Boolean.var(b)
    case .not(let b):
      if let bEval = Strategy.eval(t: b, s: s) as? Boolean {
        return Boolean.not(bEval)
      }
    case .or(let b1, let b2):
      if let b1Eval = Strategy.eval(t: b1, s: s) as? Boolean {
        if let b2Eval = Strategy.eval(t: b2, s: s) as? Boolean {
          return Boolean.or(b1Eval, b2Eval)
        }
      }
    case .and(let b1, let b2):
      if let b1Eval = Strategy.eval(t: b1, s: s) as? Boolean {
        if let b2Eval = Strategy.eval(t: b2, s: s) as? Boolean {
          return Boolean.and(b1Eval, b2Eval)
        }
      }
    }
    return nil
  }
}
