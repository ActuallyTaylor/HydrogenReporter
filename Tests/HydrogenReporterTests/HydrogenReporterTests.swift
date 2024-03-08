import XCTest
@testable import HydrogenReporter

final class HydrogenReporterTests: XCTestCase {
    func testLinkedList() {
        // Example usage:
        let linkedList = LinkedList<Int>()
        linkedList.append(value: 1)
        linkedList.append(value: 2)
        linkedList.append(value: 3)
        
        let elements: [Int] = linkedList.collectElements()
        
        XCTAssertEqual(elements, [3,2,1], "List not correctly stored")
    }
    
    func testReverseLinkedList() {
        // Example usage:
        let linkedList = LinkedList<Int>()
        linkedList.append(value: 1)
        linkedList.append(value: 2)
        linkedList.append(value: 3)
        
        let reversed = linkedList.reversed()
        
        let elements: [Int] = linkedList.collectElements()
        let reversedElements: [Int] = reversed.collectElements()
        XCTAssertNotEqual(elements, reversedElements, "List not reversed")
    }

    func testRemoveTail() {
        // Example usage:
        let linkedList = LinkedList<Int>()
        linkedList.append(value: 1)
        linkedList.append(value: 2)
        linkedList.append(value: 3)
        
        XCTAssertEqual(linkedList.collectElements(), [3,2,1], "List not correctly stored")
        
        let removed = linkedList.removeTail()
        
        XCTAssertEqual(linkedList.collectElements(), [3,2], "Tail was not removed")
        XCTAssertEqual(removed?.value, 1)
    }
    
    func testRemoveHead() {
        // Example usage:
        let linkedList = LinkedList<Int>()
        linkedList.append(value: 1)
        linkedList.append(value: 2)
        linkedList.append(value: 3)
        
        XCTAssertEqual(linkedList.collectElements(), [3,2,1], "List not correctly stored")
        
        let removed = linkedList.removeHead()
        
        XCTAssertEqual(linkedList.collectElements(), [2, 1], "Tail was not removed")
        XCTAssertEqual(removed?.value, 3)
    }

}
