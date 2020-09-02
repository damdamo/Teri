import XCTest
@testable import Teri

final class TeriListTests: XCTestCase {
  
  func testEqList() {
    let t1: List<Nat> = .concat(.insert(.add(.zero, .var("x")), .empty), .cons(.zero, .empty))
    let t2: List<Nat> = .concat(.insert(.add(.zero, .var("x")), .empty), .cons(.zero, .empty))
    
    XCTAssertEqual(t1, t2)
  }
  
  func testPrintList() {
    let t1: List<Nat> = .concat(.insert(.add(.zero, .var("x")), .empty), .cons(.zero, .empty))
    let t2: List<Boolean> = .cons(.true, .cons(.false, .empty))
    XCTAssertEqual(t1.description, "concat(insert(add(0, x), ε), cons(0, ε))")
    XCTAssertEqual(t2.description, "cons(true, cons(false, ε))")
  }
  
  func testAxiom() {
    let t1: List<Nat> = .insert(.succ(.zero), .cons(.zero, .cons(.zero, .empty)))
    let t2: List<Nat> = .concat(.empty, .cons(.zero, .empty))
    let t3: List<Nat> = .concat(.cons(.zero, .empty), .cons(.zero, .empty))
    
    XCTAssertEqual(Strategy.eval(t: t1, s: .axiom) as! List<Nat>, List<Nat>.cons(.succ(.zero), .cons(.zero, .cons(.zero, .empty))))
    XCTAssertEqual(Strategy.eval(t: t2, s: .axiom) as! List<Nat>, List<Nat>.cons(.zero, .empty))
    XCTAssertEqual(Strategy.eval(t: t3, s: .axiom) as! List<Nat>, List<Nat>.cons(.zero, .cons(.zero, .empty)))

  }
  
  func testInnermost() {
        
    let t1: List<Nat> = .concat(.cons(.add(.succ(.zero), .zero), .empty), .cons(.sub(.succ(.zero), .zero), .empty))
    let t2: List<Boolean> = .insert(.not(.and(.true, .false)), .cons(.true, .empty))
    let t3: List<Nat> = .concat(.insert(.var("x"), .empty), .empty)
    let t4: List<List<Nat>> = .cons(.cons(.add(.succ(.zero), .zero), .empty), .empty)
    let t5: List<Nat> = .contains(.succ(.zero), .cons(.zero, .cons(.succ(.zero), .empty)))
    let t6: List<Nat> = .contains(.succ(.succ(.zero)), .cons(.zero, .cons(.succ(.zero), .empty)))
    let t7: List<Nat> = .isEmpty(.empty)
    let t8: List<Nat> = .isEmpty(.cons(.var("x"), .var("y")))
    let t9: List<Boolean> = .size(.empty)
    let t10: List<Boolean> = .size(.cons(.true, .cons(.var("x"), .cons(.false, .empty))))
    let t11: List<Nat> = .remove(.zero, .cons(.succ(.zero), .cons(.zero, .empty)))

    XCTAssertEqual(Strategy.eval(t: t1, s: .innermost(.axiom)) as! List<Nat>, List<Nat>.cons(.succ(.zero), .cons(.succ(.zero), .empty)))
    XCTAssertEqual(Strategy.eval(t: t2, s: .innermost(.axiom)) as! List<Boolean>, List<Boolean>.cons(.true, .cons(.true, .empty)))
    XCTAssertEqual(Strategy.eval(t: t3, s: .innermost(.axiom)) as! List<Nat>, List<Nat>.cons(.var("x"), .empty))
    XCTAssertEqual(Strategy.eval(t: t4, s: .innermost(.axiom)) as! List<List<Nat>>, List<List<Nat>>.cons(.cons(.succ(.zero), .empty), .empty))
    XCTAssertEqual(Strategy.eval(t: t5, s: .innermost(.axiom)) as! Boolean, Boolean.true)
    XCTAssertEqual(Strategy.eval(t: t6, s: .innermost(.axiom)) as! Boolean, Boolean.false)
    XCTAssertEqual(Strategy.eval(t: t7, s: .innermost(.axiom)) as! Boolean, Boolean.true)
    XCTAssertEqual(Strategy.eval(t: t8, s: .innermost(.axiom)) as! Boolean, Boolean.false)
    XCTAssertEqual(Strategy.eval(t: t9, s: .innermost(.axiom)) as! Nat, Nat.zero)
    XCTAssertEqual(Strategy.eval(t: t10, s: .innermost(.axiom)) as! Nat, Nat.succ(.succ(.succ(.zero))))
    XCTAssertEqual(Strategy.eval(t: t11, s: .innermost(.axiom)) as! List<Nat>, List<Nat>.cons(.succ(.zero), .empty))

  }
  
  func testSubstitution(){
    let t1: List<Nat> = .concat(.cons(.var("x"), .empty), .cons(.zero, .var("l")))
    
    XCTAssertEqual(
      t1.substitution(dicVal: ["x": Nat.zero, "l": List<Nat>.empty]) as! List<Nat>,
      List<Nat>.concat(.cons(.zero, .empty), .cons(.zero, .empty))
    )
  }
  
  static var allTests = [
      ("testEqList", testEqList),
      ("testPrintList", testPrintList),
      ("testAxiom", testAxiom),
      ("testInnermost", testInnermost),
      ("testSubstitution", testSubstitution),
  ]
}
