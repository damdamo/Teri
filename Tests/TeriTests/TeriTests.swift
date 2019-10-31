import XCTest
@testable import Teri

final class TeriTests: XCTestCase {
  
  func testNat() {
    
    let n1: Nat = .add(.var("x"), .var("y"))
    let n2: Nat = .add(.var("y"), .var("x"))
    
    // Equality between terms
    XCTAssertEqual(Nat.zero, Nat.zero)
    XCTAssertEqual(Nat.var("x"), Nat.var("y"))
    XCTAssertEqual(Nat.succ(.zero), Nat.succ(.zero))
    XCTAssertEqual(n1, n2)
    
  }
  
  func testBoolean() {
    
    let b1: Boolean = .not(.var("x"))
    let b2: Boolean = .not(.var("y"))
    let b3: Boolean = .and(.var("x"), .not(.var("y")))
    let b4: Boolean = .and(.var("y"), .not(.var("x")))
    
    XCTAssertEqual(Boolean.true, Boolean.true)
    XCTAssertEqual(Boolean.false, Boolean.false)
    XCTAssertEqual(b1, b2)
    XCTAssertEqual(b3, b4)
    
  }
    
  static var allTests = [
      ("testNat", testNat),
      ("testBoolean", testBoolean)
  ]
}
