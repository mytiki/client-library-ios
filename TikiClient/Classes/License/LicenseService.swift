import Foundation
import TikiSdk

/// Service for managing user licenses.
public class LicenseService {

    var _isLicensed: Bool = false
    private var tikiSdk: TikiSdk = TikiSdk.instance
    // MARK: - Public Methods

    /// The terms and conditions associated with the license.
    public static var _terms = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ... (Your long terms and conditions string)"
    
    
    /// Retrieves the current license status.
    ///
    /// - Returns: `true` if the app is licensed, `false` otherwise.
    func isLicensed() -> Bool {
        return _isLicensed
    }
    
    /// Retrieves the terms and conditions associated with the license.
    ///
    /// - Returns: A string containing the terms and conditions.
    ///
    /// - Note: Replace the placeholder string with your actual terms and conditions.
    func terms() -> String {
        return LicenseService._terms
    }
    public static func setTerms(terms: String) {
        self._terms = terms
    }

    /// Retrieves an estimate of the license duration.
    ///
    /// - Returns: A `LicenseEstimate` object containing the minimum and maximum duration.
    func estimate() -> LicenseEstimate {
        return LicenseEstimate(min: 5, max: 15)
    }
    
    /// Accepts the data license agreement.
    func accept() {
        _isLicensed = true
    }

    /// Declines the data license agreement.
    func decline() {
        _isLicensed = false
    }

    /// Retrieves earnings information related to the license.
    ///
    /// - Returns: A `LicenseEarnings` object containing total earnings, rating, and bonus.
    func earnings() -> LicenseEarnings {
        return LicenseEarnings(total: 34.30, rating: 4.8, bonus: 12.00)
    }

    /// Creates a new license for the user.
    ///
    /// - Returns: The created `LicenseRecord`.
    public func create(userId: String, terms: String) async throws -> LicenseRecord {
        var title = try await tikiSdk.trail.title.get(ptr: userId)
        if(title == nil){
           title = try await tikiSdk.trail.title.create(
               ptr: userId,
               tags: [Tag(tag:TagCommon.PURCHASE_HISTORY)])
        }
        var license = try await tikiSdk.trail.license.create(
           titleId: title!.id,
           uses: [Use(usecases: [Usecase(usecase: UsecaseCommon.analytics)], destinations: ["*"])],
           terms: terms
        )
        return license!
    }

    /// Retrieves the user's active license.
    ///
    /// - Returns: The user's active `LicenseRecord`.
    public func get(userId: String) async throws -> LicenseRecord? {
        let licenses = try await tikiSdk.trail.license.all(titleId: userId)
        return licenses.first
    }

    /// Revokes the user's existing license.
    ///
    /// - Returns: The revoked `LicenseRecord`.
    public func revoke(userId: String) async throws -> LicenseRecord {
        var title = try await tikiSdk.trail.title.get(ptr: userId)
        if(title == nil){
           title = try await tikiSdk.trail.title.create(
               ptr: userId,
               tags: [Tag(tag:TagCommon.PURCHASE_HISTORY)])
        }
        var license = try await tikiSdk.trail.license.create(
           titleId: title!.id,
           uses: [],
           terms: "revoked license"
        )
        return license!
    }

    /// Verifies the validity of the user's license.
    ///
    /// - Returns: True if the license is valid, false otherwise.
    public func verify(userId:String) async throws -> Bool {
        return try await tikiSdk.trail.guard(ptr: userId, usecases: [Usecase(usecase: UsecaseCommon.analytics)])
    }
    
}
