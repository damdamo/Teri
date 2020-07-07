/// Description of Booleans
public indirect enum Boolean: Equatable {
  case `true`
  case `false`
  case not(Boolean)
  case or(Boolean, Boolean)
  case and(Boolean, Boolean)
  case `var`(String)

  public static func rewriting(_ t: Term) -> Term? {
    switch t {
    case .b(let st):
      switch st {
//      case .true:
//        return .b(.true)
//      case .false:
//        return .b(.false)
//      case .var(let x):
//        return .b(.var(x))
      case .not(let b):
        if let r = fNot(b) {
          return .b(r)
        }
      case .or(let b1, let b2):
        if let r = fOr(b1, b2) {
          return .b(r)
        }
      case .and(let b1, let b2):
        if let r = fAnd(b1, b2) {
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
    case .b(let st):
      switch st {
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
    default:
      return nil
    }
  }
  
  static func fNot(_ b: Boolean) -> Boolean? {
    switch b {
    case .false:
      return .true
    case .true:
      return .false
    default:
      return nil
    }
  }
  
  static func fOr(_ b1: Boolean,_ b2: Boolean) -> Boolean? {
    switch (b1,b2) {
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
  
  static func fAnd(_ b1: Boolean, _ b2: Boolean) -> Boolean? {
    switch (b1,b2) {
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
