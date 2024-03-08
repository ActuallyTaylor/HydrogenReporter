import Foundation

protocol Copying {
    init(instance: Self)
}

extension Copying {
    public func copy() -> Self {
        return Self.init(instance: self)
    }
}
