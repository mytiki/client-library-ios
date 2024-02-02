/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import Foundation

extension UIViewController {
    
    func presentInKeyWindow(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?
                .present(self, animated: animated, completion: completion)
        }
    }
    
    func presentInKeyWindowPresentedController(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindowPresentedController?
                .present(self, animated: animated, completion: completion)
        }
    }
    
}
