import XCTest
@testable import Teri

final class TeriNatTests: XCTestCase {
  
  func testNat() {
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
  
  func testEqNat() {
    let t1: Nat = .var("x")
    let t2: Nat = .var("y")
    
    XCTAssertEqual(Nat.equal(t1, t2), Boolean.false)
    XCTAssertEqual(Nat.equal(t1.anonymized(), t2.anonymized()), Boolean.true)
  }
  
 
    static var allTests = [
        ("testNat", testNat),
        ("testEqNat", testEqNat),
    ]
}
