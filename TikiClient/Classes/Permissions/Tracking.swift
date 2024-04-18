/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import AppTrackingTransparency
import AdSupport

/// Class to manage the advertising tracking
public class Tracking {
    /**
     Request tracking permission
     - Parameters:
     - completion: The callback to call when the request is completed.
     - Parameter completion: escaping closure with ATTrackingManager.AuthorizationStatus
     */
    public func askToTrack(completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .notDetermined:
                    completion(.notDetermined)
                    break
                case .restricted:
                    completion(.restricted)
                case .denied:
                    completion(.denied)
                case .authorized:
                    completion(.authorized)
                default:
                    completion(.notDetermined)
                }
            })
        }
    }
    
    /// Get the tracking identifier
    /// - Returns: The UUID of the tracking identifier
    public func getTrackingIdentifier() -> UUID? {
        if(self.isTrackingAccessAvailable())
        {
            return ASIdentifierManager.shared().advertisingIdentifier
        }
        return nil
    }
    
    /// Check if tracking permission is available
    /// - Returns: Boolean if tracking permission is available
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

