//
//  Boolean.swift
//  Teri
//
//  Created by Damien Morard on 31.10.19.
//

indirect enum Boolean {
  case `true`
  case `false`
  case not(Boolean)
  case and(Boolean, Boolean)
  case `var`(String)
}
