import XCTest
@testable import Teri

final class TeriNatTests: XCTestCase {
  
  func testAxiom() {
    let t1: Term = Nat.succ(.zero)
    let t2: Term = Nat.add(.succ(.zero), .zero)
    let t3: Term = Nat.add(.var("x"), .zero)

    // eval(s(0)) - > nil
    XCTAssertNil(Strategy.eval(t: t1, s: .axiom))
    // eval(s(0) + 0) -> s(0)
    XCTAssertEqual(Strategy.eval(t: t2, s: .axiom) as! Nat, .succ(.zero))
    // eval((0 + 0) + 0) -> 0 + 0
    XCTAssertEqual(Strategy.eval(t: t3, s: .axiom) as! Nat, .var("x"))
  }

  func testSequence() {

    let t1: Term = Nat.add(.add(.zero,.zero), .zero)
    let t2: Term = Nat.add(.succ(.add(.zero, .succ(.zero))), .zero)

    // Sequence(axiom,axiom): eval((0 + 0) + 0) -> 0
    XCTAssertEqual(Strategy.eval(t: t1, s: .sequence(.axiom, .axiom)) as! Nat, .zero)
    // Sequence(axiom,axiom): eval(add(succ(add(0, succ(0))), 0)) -> nil
    XCTAssertNil(Strategy.eval(t: t2, s: .sequence(.axiom, .axiom)))
  }

  func testChoice() {
    let t1: Nat = .succ(.zero)

    // choice(axiom, id): eval(s(0)) -> s(0)
    XCTAssertEqual(Strategy.eval(t: t1, s: .choice(.axiom, .identity)) as! Nat, t1)
  }

  func testTry() {
    let t1: Nat = .succ(.zero)

    XCTAssertEqual(Strategy.eval(t: t1, s: .try(.axiom)) as! Nat, t1)
  }

  func testAll() {

    let t1: Term = Nat.add(.add(.zero,.zero), .add(.zero, .zero))
    let t2: Term = Nat.zero
    let t3: Term = Nat.add(.add(.zero,.zero), .var("x"))

    // all(axiom): eval((0+0)+(0+0)) -> 0 + 0
    XCTAssertEqual(Strategy.eval(t: t1, s: .all(.axiom)) as! Nat, Nat.add(.zero,.zero))
    // all(axiom): eval(0) -> 0
    XCTAssertEqual(Strategy.eval(t: t2, s: .all(.axiom)) as! Nat, Nat.zero)
    XCTAssertNil(Strategy.eval(t: t3, s: .all(.axiom)))
  }

  func testInnermost() {

    let t1: Term = Nat.add(.zero, .zero)
    let t2: Term = Nat.add(.add(.zero,.zero), .add(.zero, .zero))
    let t3: Term = Nat.add(.succ(.succ(.zero)), .succ(.succ(.zero)))
    let t4: Term = Nat.var("x")
    let t5: Term = Nat.add(.add(.zero,.zero), .var("x"))
    let t6: Term = Nat.add(.var("x"),.add(.zero,.zero))
    let t7: Term = Nat.add(.zero, .var("x"))
    let t8: Term = Nat.add(.var("x"), .add(.var("y"), .zero))
    let t9: Term = Nat.eq(.var("x"), .var("y"))

    XCTAssertEqual(Strategy.eval(t: t1, s: .innermost(.axiom)) as! Nat, Nat.zero)
    XCTAssertEqual(Strategy.eval(t: t2, s: .innermost(.axiom)) as! Nat, Nat.zero)
    XCTAssertEqual(Strategy.eval(t: t3, s: .innermost(.axiom)) as! Nat, Nat.succ(.succ(.succ(.succ(.zero)))))
    XCTAssertEqual(Strategy.eval(t: t4, s: .innermost(.axiom)) as! Nat, Nat.var("x"))
    XCTAssertEqual(Strategy.eval(t: t5, s: .innermost(.axiom)) as! Nat, Nat.add(.zero,.var("x")))
    XCTAssertEqual(Strategy.eval(t: t6, s: .innermost(.axiom)) as! Nat, Nat.var("x"))
    XCTAssertEqual(Strategy.eval(t: t7, s: .innermost(.axiom)) as! Nat, Nat.add(.zero,.var("x")))
    XCTAssertEqual(Strategy.eval(t: t8, s: .innermost(.axiom)) as! Nat, Nat.add(.var("x"), .var("y")))
    XCTAssertEqual(Strategy.eval(t: t9, s: .innermost(.axiom)) as! Boolean, Boolean.false)
  }

//  func testEqNat() {
//    let t1: Nat = .eq(.var("x"), .var("y"))
//    XCTAssertEqual(t1.rewriting() as! Boolean, Boolean.false)
//
//    let t2: Nat = .var("x")
//    let t3: Nat = .var("y")
//    let t2Anonymized = t2.anonymized()
//    let t3Anonymized = t3.anonymized()
//    let t4: Nat = .eq(t2Anonymized, t3Anonymized)
//    XCTAssertEqual(t4.rewriting() as! Boolean, Boolean.true)
//  }
  
  func testSubstitution(){
    let t1: Nat = .add(.var("x"), .var("y"))
    XCTAssertEqual(t1.substitution(dicVal: ["x": Nat.succ(.zero), "y": Nat.sub(.zero, .zero)]) as! Nat, Nat.add(.succ(.zero), .sub(.zero, .zero)))
  }

  static var allTests = [
    ("testAxiom", testAxiom),
    ("testSequence", testSequence),
    ("testChoice", testChoice),
    ("testTry", testTry),
    ("testAll", testAll),
    ("testInnermost", testInnermost),
    // ("testEqNat", testEqNat),
    ("testSubstitution", testSubstitution)
  ]

}
