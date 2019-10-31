//
//  Term.swift
//  Teri
//
//  Created by Damien Morard on 18.10.19.
//

protocol PTerm: Hashable {
  
}

indirect enum Term: PTerm {
  case n(Nat)
  case b(Boolean)
}


