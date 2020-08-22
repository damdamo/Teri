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
  
  static var allTests = [
      ("testInnermost", testInnermost),
  ]
}
