// TikiClient can be initialized with a user ID and completion block
import XCTest
import Mockingbird
@testable import TikiClient

class TikiClientTests: XCTestCase {
    func test_tikiClientInitialization() {
        // Given
        let userId = "12345"
        // When
        TikiClient.configuration(config: Config(providerId: "Test 123", publicKey: "Test 1234", companyName: "TestCompany", companyJurisdiction: "US", tosUrl: "www.test.com", privacyUrl: "www.test.com"))
        TikiClient.initialize(userId: userId) { response in
            XCTAssertNil(response)
        }
    }

    // Config is nil when initializing TikiClient should throw a fatal error
    func test_tikiClientInitializationWithNilConfig() {
        // Given
        let userId = "12345"

        // When
        TikiClient.config = nil
        TikiClient.initialize(userId: userId) { error in
            XCTAssertNotNil(error)
        }
    }
}
