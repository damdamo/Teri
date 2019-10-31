//
//  Pair.swift
//  Teri
//
//  Created by Damien Morard on 28.10.19.
//

// Structure which takes two values with the same type
// Using by Rule to create condition and using the Set structure (hashable conformance)
struct Pair<T> {
  let first: T
  let second: T
}

extension Pair: Equatable where T: Equatable {

}

extension Pair: Hashable where T: Hashable {
  
}
