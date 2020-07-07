import XCTest
@testable import Teri

final class TeriBooleanTests: XCTestCase {
  
  func testInnermost() {
    let t1: Term = .b(.true)
    let t2: Term = .b(.not(.true))
    let t3: Term = .b(.and(.or(.not(.true), .var("x")), .false))
    let t4: Term = .b(.and(.var("x"), .var("y")))
    
    XCTAssertEqual(t1.eval(s: .innermost(.axiom)), Term.b(.true))
    XCTAssertEqual(t2.eval(s: .innermost(.axiom)), Term.b(.false))
    XCTAssertEqual(t3.eval(s: .innermost(.axiom)), Term.b(.false))
    XCTAssertEqual(t4.eval(s: .innermost(.axiom)), t4)
    
    // print(t4.eval(s: .innermost(.axiom)))
  }
 
    static var allTests = [
        ("testInnermost", testInnermost),
    ]
}
