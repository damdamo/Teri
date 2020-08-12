import XCTest
@testable import Teri

final class TeriNatTests: XCTestCase {
  
  func testAxiom() {
    let t1: Term = .n(.succ(.zero))
    let t2: Term = .n(.add(.succ(.zero), .zero))
    let t3: Term = .n(.add(.var("x"), .zero))
    
    // eval(s(0)) - > nil
    XCTAssertEqual(t1.eval(s: .axiom), nil)
    // eval(s(0) + 0) -> s(0)
    XCTAssertEqual(t2.eval(s: .axiom), .n(.succ(.zero)))
    // eval((0 + 0) + 0) -> 0 + 0
    XCTAssertEqual(t3.eval(s: .axiom), .n(.var("x")))
  }
  
  func testSequence() {
    
    let t1: Term = .n(.add(.add(.zero,.zero), .zero))
    let t2: Term = .n(.add(.succ(.add(.zero, .succ(.zero))), .zero))

    // Sequence(axiom,axiom): eval((0 + 0) + 0) -> 0
    XCTAssertEqual(t1.eval(s: .sequence(.axiom, .axiom)), .n(.zero))
    // Sequence(axiom,axiom): eval(add(succ(add(0, succ(0))), 0)) -> nil
    XCTAssertEqual(t2.eval(s: .sequence(.axiom, .axiom)), nil)
  }
  
  func testChoice() {
    let t1: Term = .n(.succ(.zero))
    
    // choice(axiom, id): eval(s(0)) -> s(0)
    XCTAssertEqual(t1.eval(s: .choice(.axiom, .identity)), t1)
  }
  
  func testTry() {
    let t1: Term = .n(.succ(.zero))
    
    XCTAssertEqual(t1.eval(s: .try(.axiom)), t1)
  }
  
  func testAll() {
    
    let t1: Term = .n(.add(.add(.zero,.zero), .add(.zero, .zero)))
    let t2: Term = .n(.zero)
    let t3: Term = .n(.add(.add(.zero,.zero), .var("x")))
    
    // all(axiom): eval((0+0)+(0+0)) -> 0 + 0
    XCTAssertEqual(t1.eval(s: .all(.axiom)), .n(.add(.zero,.zero)))
    // all(axiom): eval(0) -> 0
    XCTAssertEqual(t2.eval(s: .all(.axiom)), .n(.zero))
    XCTAssertEqual(t3.eval(s: .all(.axiom)), nil)
  }
  
  func testInnermost() {

    let t1: Term = .n(.add(.zero, .zero))
    let t2: Term = .n(.add(.add(.zero,.zero), .add(.zero, .zero)))
    let t3: Term = .n(.add(.succ(.succ(.zero)), .succ(.succ(.zero))))
    let t4: Term = .n(.var("x"))
    let t5: Term = .n(.add(.add(.zero,.zero), .var("x")))
    let t6: Term = .n(.add(.var("x"),.add(.zero,.zero)))
    let t7: Term = .n(.add(.zero, .var("x")))
    let t8: Term = .n(.add(.var("x"), .add(.var("y"), .zero)))
    let t9: Term = .n(.eq(.var("x"), .var("y")))

    XCTAssertEqual(t1.eval(s: .innermost(.axiom)), .n(.zero))
    XCTAssertEqual(t2.eval(s: .innermost(.axiom)), .n(.zero))
    XCTAssertEqual(t3.eval(s: .innermost(.axiom)), .n(.succ(.succ(.succ(.succ(.zero))))))
    XCTAssertEqual(t4.eval(s: .innermost(.axiom)), .n(.var("x")))
    XCTAssertEqual(t5.eval(s: .innermost(.axiom)), .n(.add(.zero,.var("x"))))
    XCTAssertEqual(t6.eval(s: .innermost(.axiom)), .n(.var("x")))
    XCTAssertEqual(t7.eval(s: .innermost(.axiom)), .n(.add(.zero,.var("x"))))
    XCTAssertEqual(t8.eval(s: .innermost(.axiom)), .n(.add(.var("x"), .var("y"))))
    XCTAssertEqual(t9.eval(s: .innermost(.axiom)), .b(.false))
  }

  func testEqNat() {
    let t1: Nat = .var("x")
    let t2: Nat = .var("y")
    
    XCTAssertEqual(t1.equal(t2), Boolean.false)
    
    let t1Anonymized = t1.anonymized()
    let t2Anonymized = t2.anonymized()
    XCTAssertEqual(t1Anonymized.equal(t2Anonymized), Boolean.true)
  }
  
  static var allTests = [
    ("testAxiom", testAxiom),
    ("testSequence", testSequence),
    ("testChoice", testChoice),
    ("testTry", testTry),
    ("testAll", testAll),
    ("testInnermost", testInnermost),
    ("testEqNat", testEqNat),
  ]
}
