/// Protocol defining the functionalities of a Tiki Client.
protocol TikiClientProtocol {
    /// Initializes the TikiClient with the given user ID.
    ///
    /// - Parameters:
    ///   - userId: The user identification.
    ///   - completion: A closure to be called once the initialization is completed or failed.
    func initialize(userId: String, completion: @escaping (String?) -> Void)
    
    /// Configures the TikiClient with the provided configuration.
    ///
    /// - Parameter config: The configuration to set.
    func configure(with config: Config)
    
    /// Creates a license for the initialized user.
    ///
    /// - Parameter completion: A closure to be called once the license creation is completed or failed.
    func createLicense(completion: @escaping (String?) -> Void)
    
    /// Retrieves terms and conditions for the TikiClient.
    ///
    /// - Parameter completion: A closure to be called once the terms are retrieved or if an error occurs.
    func terms(completion: @escaping (String?) -> Void) -> String
}