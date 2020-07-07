indirect enum Term: Equatable {
  case n(Nat)
  case b(Boolean)

  func axiom() -> Term? {
    switch self {
    case .n(_):
      return Nat.rewriting(self)
    case .b(_):
      return Boolean.rewriting(self)
    }
  }

  func sequence(s1: Strategy, s2: Strategy) -> Term? {
    if let t1 = self.eval(s: s1) {
      if let t2 = t1.eval(s: s2) {
        return t2
      }
    }
    return nil
  }
  
  func choice(s1: Strategy, s2: Strategy) -> Term? {
    if let t1 = self.eval(s: s1) {
      return t1
    } else if let t2 = self.eval(s: s2) {
      return t2
    }
    return nil
  }
  
  func all(s: Strategy) -> Term? {
    switch self {
    case .n(_):
      return Nat.all(t: self, s: s)
    case .b(_):
      return Boolean.all(t: self, s: s)
    default:
      return nil
    }
  }
  
  func eval(s: Strategy) -> Term? {
    switch s {
    case .identity:
      return self
    case .fail:
      return nil
    case .axiom:
      return self.axiom()
    case .sequence(let s1, let s2):
      return self.sequence(s1: s1, s2: s2)
    case .choice(let s1, let s2):
      return self.choice(s1: s1, s2: s2)
    case .try(let s1):
      return self.choice(s1: s1, s2: .identity)
    case .all(let s1):
      return self.all(s: s1)
    case .innermost(let s1):
      return self.eval(s: .sequence(.all(.innermost(s1)), .try(.sequence(s1, .innermost(s1)))))
//    case .bottomup(let s1):
//      let newStrat: Strategy = .sequence(<#T##Strategy#>, <#T##Strategy#>)
//      return eval(t: Term, s: )
    default:
      return nil
    }
  }
    


}

extension Term: CustomStringConvertible {
  var description: String {
    switch self {
    case .n(let x):
      return x.description
    case .b(let b):
      return b.description
    }
  }
}
