//
//  Adt.swift
//  Teri
//
//  Created by Damien Morard on 18.10.19.
//

protocol Adt: Hashable {
  associatedtype Term
  
  /// Replace function substitute some variables by a Term.
  /// For instance: ["x": 0] x + y --> 0 + y
  ///
  /// - Parameters:
  ///   - term: The term where variable(s) has to be substitute
  ///   - subsTable: A dictionnary which link which variable has to be substitute by which term
  /// - Returns: A new term where some variable(s) are replaced by a term
  static func replace(_ term:Term, subsTable: [String: Term]) -> Term
  
  /// Evaluate a term as far as possible with its variables (Apply the semantic of the term)
  /// For instance: succ(x) + succ(y) -> x + succ(succ(y))
  ///
  ///- Returns: The term evaluate
  func eval() -> Term
  

}
