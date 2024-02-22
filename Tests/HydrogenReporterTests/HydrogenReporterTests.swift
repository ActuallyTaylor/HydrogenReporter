import XCTest
@testable import HydrogenReporter

final class HydrogenReporterTests: XCTestCase {
    func testMemoryUsage() throws {
        for i in 0...100000 {
            LOG("Hello World", i)
        }
    }
}
