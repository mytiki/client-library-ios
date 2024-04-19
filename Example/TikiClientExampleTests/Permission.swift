import Foundation
import XCTest
import TikiClient


class PermissionTests: XCTestCase {
    // Verify that the name() method returns the correct name for each permission.
    func test_name_method_returns_correct_name() {
        let cameraPermission = Permission.camera
        XCTAssertEqual(cameraPermission.name(), "camera")
        
        let microphonePermission = Permission.microphone
        XCTAssertEqual(microphonePermission.name(), "microphone")
        
        let photoLibraryPermission = Permission.photoLibrary
        XCTAssertEqual(photoLibraryPermission.name(), "photo library")
        
        let locationInUsePermission = Permission.locationInUse
        XCTAssertEqual(locationInUsePermission.name(), "location (in use)")
        
        let locationAlwaysPermission = Permission.locationAlways
        XCTAssertEqual(locationAlwaysPermission.name(), "location (always)")
        
        let notificationsPermission = Permission.notifications
        XCTAssertEqual(notificationsPermission.name(), "notifications")
        
        let calendarPermission = Permission.calendar
        XCTAssertEqual(calendarPermission.name(), "calendar")
        
        let contactsPermission = Permission.contacts
        XCTAssertEqual(contactsPermission.name(), "contacts")
        
        let remindersPermission = Permission.reminders
        XCTAssertEqual(remindersPermission.name(), "reminders")
        
        let speechRecognitionPermission = Permission.speechRecognition
        XCTAssertEqual(speechRecognitionPermission.name(), "speech recognition")
        
        let healthPermission = Permission.health
        XCTAssertEqual(healthPermission.name(), "health")
        
        let mediaLibraryPermission = Permission.mediaLibrary
        XCTAssertEqual(mediaLibraryPermission.name(), "media library")
        
        let motionPermission = Permission.motion
        XCTAssertEqual(motionPermission.name(), "motion")
        
        let trackingPermission = Permission.tracking
        XCTAssertEqual(trackingPermission.name(), "tracking")
    }

}
