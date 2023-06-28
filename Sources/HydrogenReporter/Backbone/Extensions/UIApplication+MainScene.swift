import UIKit

/// https://stackoverflow.com/a/68989580/14886210
extension UIApplication {
    var mainScene: UIScene? {
        return UIApplication.shared.connectedScenes
            .first(where: {$0.activationState == .foregroundActive})
    }
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
}

