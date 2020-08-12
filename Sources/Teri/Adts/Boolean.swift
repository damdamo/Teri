/// Description of Booleans
public indirect enum Boolean: PTerm {
  case `true`
  case `false`
  case not(Boolean)
  case or(Boolean, Boolean)
  case and(Boolean, Boolean)
  case `var`(String)

  public func rewriting() -> Term? {
    switch self {
    case .not(let b):
      if let r = b.fNot() {
        return .b(r)
      }
    case .or(let b1, let b2):
      if let r = b1.fOr(b2) {
        return .b(r)
      }
    case .and(let b1, let b2):
      if let r = b1.fAnd(b2) {
        return .b(r)
      }
    default:
      return nil
    }
    return nil
  }
  
  public func all(s: Strategy) -> Term? {
    switch self {
    case .true:
      return .b(.true)
      case .false:
        return .b(.false)
    case .var(let b):
      return .b(.var(b))
    case .not(let b):
      let t1 = Term.b(b).eval(s: s)
      switch t1 {
      case .b(let bEval):
        return .b(.not(bEval))
      default:
        return nil
      }
    case .and(let b1, let b2):
      let t1 = Term.b(b1).eval(s: s)
      let t2 = Term.b(b2).eval(s: s)
      switch (t1, t2) {
      case (.b(let b1Eval), .b(let b2Eval)):
        return .b(.and(b1Eval, b2Eval))
      default:
        return nil
      }
    case .or(let b1, let b2):
      let t1 = Term.b(b1).eval(s: s)
      let t2 = Term.b(b2).eval(s: s)
      switch (t1, t2) {
      case (.b(let b1Eval), .b(let b2Eval)):
        return .b(.or(b1Eval, b2Eval))
      default:
        return nil
      }
    }
  }
  
  func fNot() -> Boolean? {
    switch self {
    case .false:
      return .true
    case .true:
      return .false
    default:
      return nil
    }
  }
  
  func fOr(_ b: Boolean) -> Boolean? {
    switch (self,b) {
    case (.true, _):
      return .true
    case (_,.true):
      return .true
    case (.false, .false):
      return .false
    default:
      return nil
    }
  }
  
  func fAnd(_ b: Boolean) -> Boolean? {
    switch (self,b) {
    case (.false, _):
      return .false
    case (_,.false):
      return .false
    case (.true, .true):
      return .true
    default:
      return nil
    }
  }

}
