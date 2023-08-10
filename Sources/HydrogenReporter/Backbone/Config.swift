//
//  Config.swift
//  
//
//  Created by Taylor Lineman on 4/23/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public enum AppConfiguration {
    case Debug
    case TestFlight
    case AppStore
}

public enum AppAppearance {
    case dark
    case light
}

public struct Config {
    // This is private because the use of 'appConfiguration' is preferred.
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    
    // This can be used to add debug statements.
    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    public static var appConfiguration: AppConfiguration {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
    
    static var appConfigString: String {
        if isDebug {
            return "Debug"
        } else if isTestFlight {
            return "Test Flight"
        } else {
            return "App Store"
        }
    }
    
    static var appAppearance: AppAppearance {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return .dark
        } else if UITraitCollection.current.userInterfaceStyle == .light {
            return .light
        } else {
            return .light
        }
    }
}
