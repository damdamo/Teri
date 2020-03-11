//
//  Pair.swift
//  Teri
//
//  Created by Damien Morard on 05.02.20.
//


// Structure which takes two values with the same type
// Using by Rule to create condition and using the Set structure (hashable conformance)
struct Pair<T> {
  let l: T
  let r: T
  
  public init(l: T, r: T) {
    self.l = l
    self.r = r
  }
  
}

extension Pair: Equatable where T: Equatable {

}

extension Pair: Hashable where T: Hashable {
  
}
