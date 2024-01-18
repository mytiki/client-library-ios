import Foundation

/// The company legal information. It is used to set up the terms for the licensed data.
public struct Company {

    /// The business legal name. e.g.: "Company Inc"
    public let name: String

    /// The jurisdiction in which the business is established. e.g.: "Tennessee, USA"
    public let jurisdiction: String

    /// The business privacy terms URL. e.g: "https://companyinc.com/privacy"
    public let privacy: String

    /// The user terms and conditions URL. e.g: "https://companyinc.com/terms"
    public let terms: String

    /// Initializes a new instance of `Company`.
    ///
    /// - Parameters:
    ///   - name: The business legal name.
    ///   - jurisdiction: The jurisdiction in which the business is established.
    ///   - privacy: The business privacy terms URL.
    ///   - terms: The user terms and conditions URL.
    public init(name: String, jurisdiction: String, privacy: String, terms: String) {
        self.name = name
        self.jurisdiction = jurisdiction
        self.privacy = privacy
        self.terms = terms
    }
}
