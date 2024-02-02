import Foundation
import TikiSdk

/// Service for managing user licenses.
public class LicenseService {
    private var tikiSdk: TikiSdk = TikiSdk.instance
    
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
