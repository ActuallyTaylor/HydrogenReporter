/*
 An O(1) insertion linked list.
 Elements are in reverse order to allow for insertion to happen in O(1) time complexity.
 This data structure was selected because HydrogenReporter rarely needs to loop over the list of logs.
 When it does this we can take the hit of having to reverse the linked list
*/
import Foundation

public class ListNode<T>: Copying {
    public var value: T
    public var next: ListNode<T>?
    
    public init(value: T) {
        self.value = value
        self.next = nil
    }
    
    required init(instance: ListNode<T>) {
        self.value = instance.value
        self.next = instance.next
    }

}

public class LinkedList<T>: Copying {
    public var head: ListNode<T>?
    public var count: Int = 0
    
    public init() { }
    
    required init(instance: LinkedList<T>) {
        self.head = instance.head
        self.count = instance.count
    }

    public func append(value: T) {
        let newNode = ListNode(value: value)
        newNode.next = head
        head = newNode
        
        count += 1
    }
    
    @discardableResult
    public func removeTail() -> ListNode<T>? {
        var previous: ListNode<T>? = nil
        var last: ListNode<T>? = self.head

        while last?.next != nil {
            previous = last
            last = last?.next
        }
        
        previous?.next = nil
        
        return last
    }
    
    @discardableResult
    public func removeHead() -> ListNode<T>? {
        let hold = self.head
        self.head = self.head?.next
        return hold
    }
        
    /// Reverses the current linked list.
    /// Does not modify the current list
    /// - Returns: A reversewd copy of this linked list.
    public func reversed() -> LinkedList<T> {
        let listCopy: LinkedList<T> = self.copy()
        var current: ListNode<T>? = listCopy.head
        var previous: ListNode<T>?
        var next: ListNode<T>?
        
        while current != nil {
            next = current?.next
            current?.next = previous
            previous = current
            current = next
        }
        listCopy.head = previous

        return listCopy
    }
    
    public func collectElements() -> [T] {
        var elements: [T] = []
        var current: ListNode<T>? = self.head

        while current != nil {
            if let current {
                elements.append(current.value)
            }

            current = current?.next
        }
        return elements
    }

}
