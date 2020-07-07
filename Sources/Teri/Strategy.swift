/// Enum of the different strategies:
/// Generators: identity / fail / axiom / sequence / choice / all
/// Bonus: try / repeat / bottomup / topdown / innermost
public indirect enum Strategy {
  // Generators
  case identity
  case fail
  case axiom
  case sequence(Strategy, Strategy)
  case choice(Strategy, Strategy)
  case all(Strategy)
  // Bonus
  case `try`(Strategy)
  case `repeat`(Strategy)
  case bottomup(Strategy)
  case topdown(Strategy)
  case innermost(Strategy)
  
}
