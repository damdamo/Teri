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

    // [x=0,y=1] x + y -> 0 + 1
    XCTAssertEqual(Nat.replace(n1, subsTable: ["x": .zero, "y": .succ(.zero)]), .add(.zero, .succ(.zero)))
    // [y=1] x + y -> x + 1
    XCTAssertEqual(Nat.replace(n1, subsTable: ["y": .succ(.zero)]), .add(.var("x"), .succ(.zero)))
    // [y=succ(z)] x + y -> x + succ(z)
    XCTAssertEqual(Nat.replace(n1, subsTable: ["y": .succ(.var("z"))]), .add(.var("x"), .succ(.var("z"))))
    // [x=0, y=succ(x)] x + y -> 0 + succ(x)
    XCTAssertEqual(Nat.replace(n1, subsTable: ["x": .zero, "y": .succ(.var("x"))]), .add(.zero, .succ(.var("x"))))

    let n7: Nat = .add(.succ(.succ(.zero)), .succ(.zero))
    let n8: Nat = .add(.succ(.succ(.zero)), .succ(.var("x")))
    let n9: Nat = .add(.succ(.var("x")), .succ(.var("y")))
    let n10: Nat = .add(.succ(.zero), .add(.zero, .zero))
    
    // Eval: succ(succ(0)) + succ(0) = succ(succ(succ(0)))
    XCTAssertEqual(n7.eval(), Nat.succ(.succ(.succ(.zero))))
    // succ(succ(0)) + succ(x) = succ(succ(succ(x)))
    XCTAssertEqual(n8.eval(), .succ(.succ(.succ(.var("x")))))
    // succ(x) + succ(y) -> x + succ(succ(y))
    XCTAssertEqual(n9.eval(), Nat.add(.var("x"), .succ(.succ(.var("y")))))
    // succ(0) + (0 + 0) -> succ(0)
    XCTAssertEqual(n10.eval(), Nat.succ(.zero))
    
  }
  
  func testBoolean() {
    
    let b1: Boolean = .not(.var("b"))
    let b2: Boolean = .not(.var("b"))
    let b3: Boolean = .and(.var("b1"), .not(.var("b2")))
    let b4: Boolean = .and(.var("b2"), .not(.var("b1")))
    
    XCTAssertEqual(Boolean.true, Boolean.true)
    XCTAssertEqual(Boolean.false, Boolean.false)
    XCTAssertEqual(b1, b2)
    XCTAssertEqual(b3, b4)
    
    // [b1=true, b2=not(false)] b1 and not(b2) -> true and not(not(false))
    XCTAssertEqual(Boolean.replace(b3, subsTable: ["b1": .true, "b2": .not(.false)]), .and(.true, .not(.not(.false))))
    
    
    let b5: Boolean = .and(.not(.false), .and(.and(.true, .not(.true)), .var("x")))
    let b6: Boolean = .and(.not(.not(.true)), .and(.and(.true, .true), .var("x")))
    
    XCTAssertEqual(b5.eval(), .false)
    XCTAssertEqual(b6.eval(), .and(.true, .and(.true, .var("x"))))
  }
    
  static var allTests = [
      //("testNat", testNat),
      ("testBoolean", testBoolean)
  ]
}
