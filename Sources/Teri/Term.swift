public protocol Term {
  
  /// Rewrite a term by applying the first available rule
  /// Returns: The result of the application of a rule on the term. If there is no rule to apply, it returns nil.
  func rewriting() -> Term?
  
  /// Apply the stragegy to all of direct subterms inside the term.
  /// For instance: add(x,y), apply the strategy to subterms x and y
  /// - Parameters:
  ///   - s: The strategy to use
  /// Returns: The result of the evaluate term with the given strategy. If it fails, returns nil.
  func all(s: Strategy) -> Term?
  
  /// Substitute given variables in a term
  /// - Parameters:
  ///   - dicVal: Dictionary where the key is the variable name and the value is the corresponding term
  /// Returns: The result of the substitution of the term. If the term to substitute has not the good type, it returns nil.
  /// For instance, the substitution of a Boolean term in a Natural term returns nil.
  func substitution(dicVal: [String: Term]) -> Term?
}
