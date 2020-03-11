/// Description of Booleans
indirect enum Boolean: Equatable {
  case `true`
  case `false`
  case not(Boolean)
  case or(Boolean, Boolean)
  case and(Boolean, Boolean)
  case `var`(String)

  static func rewriting(_ t: Term) -> Term? {
    switch t {
    case .b(let st):
      switch st {
//      case .true:
//        return .b(.true)
//      case .false:
//        return .b(.false)
//      case .var(let x):
//        return .b(.var(x))
      case .not(let x):
        return .b(fNot(x))
      case .or(let x, let y):
        return .b(fOr(x,y))
      case . and(let x, let y):
        return .b(fAnd(x,y))
      default:
        return nil
      }
    default:
      return nil
    }
  }
  
  static func fNot(_ b: Boolean) -> Boolean {
    switch b {
    case .false:
      return .true
    case .true:
      return .false
    default:
      return .not(b)
    }
  }
  
  static func fOr(_ b1: Boolean,_ b2: Boolean) -> Boolean {
    switch (b1,b2) {
    case (.true, _):
      return .true
    case (_,.true):
      return .true
    case (.false, .false):
      return .false
    default:
      return .or(b1,b2)
    }
  }
  
  static func fAnd(_ b1: Boolean, _ b2: Boolean) -> Boolean {
    switch (b1,b2) {
    case (.false, _):
      return .false
    case (_,.false):
      return .false
    case (.true, .true):
      return .true
    default:
      return .and(b1,b2)
    }
  }

}


//enum RuleName {
//  case not
//  case or
//  case and
//}
//
//func rewritingStep(t: Term, ruleName: RuleName) -> Term {
//  switch t {
//  case .b(let st):
//    switch ruleName {
//    case .not:
//      switch st {
//      case .not(let b):
//        return .b(fNot(b))
//      default:
//        return t
//      }
//    case .or:
//      switch st {
//      case .or(let b1, let b2):
//        return .b(fOr(b1, b2))
//      default:
//        return t
//      }
//    case .and:
//      switch st {
//      case .and(let b1, let b2):
//        return .b(fAnd(b1, b2))
//      default:
//        return t
//      }
//    }
//  default:
//    return t
//  }
//}
