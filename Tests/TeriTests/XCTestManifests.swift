import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TeriStrategiesTests.allTests),
        testCase(TeriNatTests.allTests),
    ]
}
#endif
