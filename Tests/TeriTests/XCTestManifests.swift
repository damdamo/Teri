import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TeriNatTests.allTests),
        testCase(TeriBooleanTests.allTests),
    ]
}
#endif
