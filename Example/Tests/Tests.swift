import XCTest
import TikiClient

class Tests: XCTestCase {
    
    func testSaveAndGetEmailRepository(){
        EmailRepository.SaveEmailToken(authToken: AuthToken(auth: "Test password token", refresh: "", expiration: nil), email: "test@test.com")
        let savedToken = EmailRepository.ReadEmailToken(email: "test@test.com")
        XCTAssertEqual(savedToken.auth, "Test password token")
    }
    func testUpdateAndDeleteEmailRepository(){
        EmailRepository.UpdateEmailToken(authToken: AuthToken(auth: "Second token", refresh: "", expiration: nil), email: "test@test.com")
        XCTAssertEqual(EmailRepository.ReadEmailToken(email: "test@test.com").auth, "Second token")
    }
}
