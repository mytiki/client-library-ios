import Foundation
import AppTrackingTransparency
import TikiClient
import XCTest

class TrackTest: XCTestCase {
    
    func test_requestTrackingPermission_authorizedStatus() {
        // Arrange
        let tracking = TikiClient.tracking
        var authorizationStatus: ATTrackingManager.AuthorizationStatus?
        
        // Act
        tracking.askToTrack { status in
            // Assert
            XCTAssertTrue(status == .authorized || status == .notDetermined)
        }
    }
}
