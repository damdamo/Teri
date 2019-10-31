//
//  proofs.swift
//  Teri
//
//  Created by Damien Morard on 22.10.19.
//

//struct Proofs<T: Hashable> {
//
//  typealias Term = T
//  
//  func reflexivity(term: Term) -> Rule<Term> {
//    return Rule(leftTerm: term, rightTerm: term)
//  }
//  
//  func symmetry(rule: Rule<T>) -> Rule<T> {
//    return Rule(leftTerm: rule.rightTerm, rightTerm: rule.leftTerm, cond: rule.cond)
//  }
//
//  func substitutivity(rule: Rule<T>, op: (Term) -> Term) -> Rule<T> {
//    return Rule(leftTerm: op(rule.leftTerm), rightTerm: op(rule.rightTerm), cond: rule.cond)
//  }
//  
//  func transitivity(rule1: Rule<T>, rule2: Rule<T>) -> Rule<T>? {
//    if rule1.rightTerm == rule2.leftTerm {
//      if let cond1 = rule1.cond, let cond2 = rule2.cond {
//        return Rule(leftTerm: rule1.leftTerm, rightTerm: rule2.rightTerm, cond: cond1.union(cond2))
//      } else if let cond1 = rule1.cond {
//        return Rule(leftTerm: rule1.leftTerm, rightTerm: rule2.rightTerm, cond: cond1)
//      } else if let cond2 = rule2.cond {
//        return Rule(leftTerm: rule1.leftTerm, rightTerm: rule2.rightTerm, cond: cond2)
//      }
//      return Rule(leftTerm: rule1.leftTerm, rightTerm: rule2.rightTerm)
//    }
//    return nil
//  }
//  
//  
//}
