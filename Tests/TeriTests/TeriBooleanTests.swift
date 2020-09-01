import XCTest
@testable import Teri

final class TeriBooleanTests: XCTestCase {
  
  func testInnermost() {
    let t1: Boolean = Boolean.true
    let t2: Boolean = Boolean.not(.true)
    let t3: Boolean = Boolean.and(.or(.not(.true), .var("x")), .false)
    let t4: Boolean = Boolean.and(.var("x"), .var("y"))

    XCTAssertEqual(Strategy.eval(t: t1, s: .innermost(.axiom)) as! Boolean, Boolean.true)
    XCTAssertEqual(Strategy.eval(t: t2, s: .innermost(.axiom)) as! Boolean, Boolean.false)
    XCTAssertEqual(Strategy.eval(t: t3, s: .innermost(.axiom)) as! Boolean, Boolean.false)
    XCTAssertEqual(Strategy.eval(t: t4, s: .innermost(.axiom)) as! Boolean, t4)

  }
  
  func testSubstitution(){
    let t1: Boolean = .and(.not(.var("x")), .var("y"))
    XCTAssertEqual(t1.substitution(dicVal: ["x": Boolean.true, "y": Boolean.false]) as! Boolean, Boolean.and(.not(.true), .false))
    XCTAssertNil(t1.substitution(dicVal: ["x": Nat.zero, "y": Boolean.false]))
  }
  
  static var allTests = [
      ("testInnermost", testInnermost),
  ]
}
