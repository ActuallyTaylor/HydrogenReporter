import XCTest
@testable import HydrogenReporter

final class HydrogenReporterTests: XCTestCase {
    func testMemoryUsage() throws {
        for i in 0...5000 {
            LOG("Hello World", i)
        }
        for i in 0...5000 {
            print("Hello World", i)
        }

    }
}
