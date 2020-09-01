extension List: Equatable {
  public static func == (lhs: List<T>, rhs: List<T>) -> Bool {
    switch (lhs, rhs) {
    case (.empty, .empty):
      return true
    case (.cons(let t1, let l1), .cons(let t2, let l2)):
      if t1 == t2 {
        return l1 == l2
      }
    case (.insert(let t1, let l1), .insert(let t2, let l2)):
      if t1 == t2 {
        return l1 == l2
      }
    case (.concat(let l1, let l2), .concat(let l3, let l4)):
      if l1 == l3 && l2 == l4 {
        return true
      }
    case (.var(let t1), .var(let t2)):
      if t1 == t2 {
        return true
      }
    default:
      return false
    }
    return false
  }
}

extension List: CustomStringConvertible {
  public var description: String {
    switch self {
    case .empty:
      return "ε"
    case .var(let t):
      return t
    case .cons(let t, let l):
      return "cons(\(t), \(l))"
    case .insert(let t, let l):
      return "insert(\(t), \(l))"
    case .concat(let l1, let l2):
      return "concat(\(l1), \(l2))"
    }
  }
  
}
