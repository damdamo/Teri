//
//  Rules.swift
//  Teri
//
//  Created by Damien Morard on 05.02.20.
//

//struct Rule<T: Hashable> where T: Adt {
//
//  typealias Cond = Set<Pair<T>>?
//
//  let lTerm: T
//  let rTerm: T
//  let cond: Cond
//
//  public init(_ lTerm: T, _ rTerm: T, cond: Cond = nil ) {
//    self.lTerm = lTerm
//    self.rTerm = rTerm
//    self.cond = cond
//  }
//
//  func symmetry() -> Rule<T> {
//    return Rule<T>(self.rTerm, self.lTerm)
//  }
//
//  func substitutivity(op: String, otherTerms: T...) -> Rule<T>? {
//    guard T.operations.contains(op) else {
//      return nil
//    }
//    return nil
//  }
//
//}
