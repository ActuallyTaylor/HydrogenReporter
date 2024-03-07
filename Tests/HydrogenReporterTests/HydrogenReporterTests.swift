import XCTest
@testable import HydrogenReporter

final class HydrogenReporterTests: XCTestCase {
    
    func testAppendRepeatedly() {
        for i in 0..<100000 {
            LOG("Test log", i, level: .info)
        }
    }
}
