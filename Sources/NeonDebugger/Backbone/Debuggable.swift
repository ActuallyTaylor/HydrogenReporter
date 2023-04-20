//
//  Debuggable.swift
//  
//
//  Created by Taylor Lineman on 4/19/23.
//

import Swift
import SwiftUI

protocol Debuggable {
    var swiftyDebugDescription: String { get }
    var swiftyLongDescription: String { get }
}

extension Debuggable {
    var swiftyLongDescription: String {
        get {
            return swiftyDebugDescription
        }
    }
}

// MARK: Swift
extension Swift.Optional: Debuggable {
    var swiftyDebugDescription: String {
        if let self {
            if let self = self as? Debuggable {
                return self.swiftyDebugDescription
            } else {
                return "Non Debuggable Optional Variable"
            }
        } else {
            return "Nil"
        }
    }
}

extension Swift.String: Debuggable {
    var swiftyDebugDescription: String {
        return self
    }
}

extension Swift.Int: Debuggable {
    var swiftyDebugDescription: String {
        return self.description
    }
}

extension Swift.Bool: Debuggable {
    var swiftyDebugDescription: String {
        return self.description
    }
}

extension Swift.Double: Debuggable {
    var swiftyDebugDescription: String {
        return self.description
    }
}

extension Swift.UInt8: Debuggable {
    var swiftyDebugDescription: String {
        self.description
    }
}

extension Swift.Array: Debuggable {
    var swiftyDebugDescription: String {
        self.map { element in
            if let debugElement = element as? Debuggable {
                return debugElement.swiftyLongDescription
            } else {
                return "Non Debuggable Element"
            }
        }.joined(separator: ", ")
    }
}

extension Swift.Float: Debuggable {
    var swiftyDebugDescription: String {
        self.description
    }
}

extension Swift.Int32: Debuggable {
    var swiftyDebugDescription: String {
        self.description
    }
}

extension Swift.Set: Debuggable {
    var swiftyDebugDescription: String {
        self.map { element in
            if let debugElement = element as? Debuggable {
                return debugElement.swiftyLongDescription
            } else {
                return "Non Debuggable Element"
            }
        }.joined(separator: ", ")
    }
}

extension Swift.UInt: Debuggable {
    var swiftyDebugDescription: String {
        self.description
    }
}

extension Swift.UInt32: Debuggable {
    var swiftyDebugDescription: String {
        self.description
    }
}

extension Swift.Int64: Debuggable {
    var swiftyDebugDescription: String {
        self.description
    }
}

extension Swift.Result: Debuggable {
    var swiftyDebugDescription: String {
        do {
            let value = try self.get()
            return "Success: \(value)"
        } catch {
            return "Failure \(error.localizedDescription)"
        }
    }
    
    var swiftyLongDescription: String {
        do {
            let value = try self.get()
            return "Success: \(value)"
        } catch {
            return "Failure \(error)"
        }
    }
}

extension Swift.AnyBidirectionalCollection: Debuggable {
    var swiftyDebugDescription: String {
        self.map { element in
            if let debugElement = element as? Debuggable {
                return debugElement.swiftyLongDescription
            } else {
                return "Non Debuggable Element"
            }
        }.joined(separator: ", ")
    }
}

extension Swift.AnyCollection: Debuggable {
    var swiftyDebugDescription: String {
        self.map { element in
            if let debugElement = element as? Debuggable {
                return debugElement.swiftyLongDescription
            } else {
                return "Non Debuggable Element"
            }
        }.joined(separator: ", ")
    }
}

extension Swift.AnyHashable: Debuggable {
    var swiftyDebugDescription: String {
        self.description
    }
}

extension Swift.AnyIndex: Debuggable {
    // TODO: Find a better way to print an AnyIndex
    var swiftyDebugDescription: String {
        "\(self)"
    }
}

extension Swift.AnyIterator: Debuggable {
    // TODO: Find a better way to print an Any Iterator
    var swiftyDebugDescription: String {
        "\(self)"
    }
}

extension Swift.AnyKeyPath: Debuggable {
    var swiftyDebugDescription: String {
        if #available(iOS 16.4, *) {
            return self.debugDescription
        } else {
            return "\(self)"
        }
    }
}

extension Swift.AnyRandomAccessCollection: Debuggable {
    var swiftyDebugDescription: String {
        self.map { element in
            if let debugElement = element as? Debuggable {
                return debugElement.swiftyLongDescription
            } else {
                return "Non Debuggable Element"
            }
        }.joined(separator: ", ")
    }
}

extension Swift.AnySequence: Debuggable {
    var swiftyDebugDescription: String {
        self.map { element in
            if let debugElement = element as? Debuggable {
                return debugElement.swiftyLongDescription
            } else {
                return "Non Debuggable Element"
            }
        }.joined(separator: ", ")
    }
}

extension Swift.ArraySlice: Debuggable {
    var swiftyDebugDescription: String {
        self.description
    }
}

extension Swift.AutoreleasingUnsafeMutablePointer: Debuggable {
    var swiftyDebugDescription: String {
        self.debugDescription
    }
}

// MARK: SwiftUI
extension SwiftUI.State: Debuggable {
    var swiftyDebugDescription: String {
        (self.wrappedValue as? Debuggable)?.swiftyDebugDescription ?? "Non Debuggable State Variable"
    }
}

extension SwiftUI.StateObject: Debuggable {
    var swiftyDebugDescription: String {
        (self.wrappedValue as? Debuggable)?.swiftyLongDescription ?? "Non Debuggable State Object"
    }
}
