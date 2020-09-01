public protocol Term {
  func rewriting() -> Term?
  func all(s: Strategy) -> Term?
}
