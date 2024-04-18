/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import AppTrackingTransparency
import AdSupport

public class Tracking {
    
    public func askToTrack(completion: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .notDetermined:
                    completion("Unknown consent")
                    break
                case .restricted:
                    completion("Device has an MDM solution applied")
                case .denied:
                    completion("Denied consent")
                case .authorized:
                    completion("Granted consent, The Traking Identifier is: \(self.getTrackingIdentifier()?.uuidString)")
                default:
                    completion("Unknown")
                }
            })
        }
    }
    
    
    public func getTrackingIdentifier() -> UUID? {
        if(self.isTrackingAccessAvailable())
        {
            return ASIdentifierManager.shared().advertisingIdentifier
        }
        return nil
    }
    
    public func isTrackingAccessAvailable() -> Bool {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized:
            return true
        case .notDetermined,.restricted,.denied:
            return false
        @unknown default:
            return false
        }
    }
}

