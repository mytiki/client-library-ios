/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

/// # AccountService
///
/// The `AccountService` class manages user accounts, providing methods for retrieving account
/// information, handling logins, and managing sessions.
///
/// ## Overview
///
/// The `AccountService` class is responsible for maintaining a collection of 3rd party accounts,
/// allowing for account retrieval based on providers and performing login and logout operations.
///
/// ## Example
///
/// To use the `AccountService` class, follow the example below:
///
/// ```swift
/// let accountService = AccountService()
///
/// // Retrieve all accounts
/// let allAccounts = accountService.accounts()
///
/// // Retrieve accounts for a specific provider
/// let facebookAccounts = accountService.accounts(for: .facebook)
///
/// // Retrieve available account providers
/// let availableProviders = accountService.providers()
public class AccountService{
// MARK: - Properties

/// An array containing the user accounts managed by the service.
    var _accounts: [Account] = EmailService.accounts()

// MARK: - Public Methods

/// Retrieves all user accounts stored in the service.
///
/// - Returns: An array of user accounts.
func accounts() -> [Account] {
    _accounts = EmailService.accounts()
    return _accounts
}

/// Retrieves user accounts associated with a specific `AccountProvider`.
///
/// - Parameter provider: The account provider for which accounts should be retrieved.
/// - Returns: An array of user accounts for the specified provider.
func accounts(for provider: AccountProvider) -> [Account] {
    accounts()
    var accounts: [Account] = []
    _accounts.forEach { acc in
        if acc.provider == provider { accounts.append(acc) }
    }
    return accounts
}

/// Retrieves available `AccountProvider`, excluding those already associated with existing accounts.
///
/// - Returns: An array of available account providers.
func providers() -> [AccountProvider] {
    var providers = AccountProvider.all()
    _accounts.forEach { acc in
        let index = providers.firstIndex(where: {
            acc.provider.name() == $0.name()
        })
    }
    return providers
}

/// Logs in a user by creating a new account or verifying an existing one.
///
/// - Parameters:
///   - username: The username for the account.
///   - password: The password for the account.
///   - provider: The account provider for the login.
/// - Returns: The logged-in user account.
/// - Throws: An error indicating issues with the login process, such as empty credentials or an already linked account.
func login(username: String, password: String, provider: AccountProvider) throws -> Account {
    if username.isEmpty || password.isEmpty {
        throw TikiError.error("Username and password should not be empty.")
    } else {
        if _accounts.first(where: {
            $0.username == username &&
                $0.provider == provider &&
                $0.status == .verified
        }) != nil {
            throw TikiError.error("Account already linked.")
        } else {
            let account = Account(username: username, provider: provider)
            var accountType: AccountType?
            switch(provider){
            case .email(let emailEnum):
                accountType = .email(emailEnum)
                break
            }
            _accounts.append(Account(username: username, provider: provider))

            return account
        }
    }
}

/// Logs out a user by removing the associated account.
///
/// - Parameters:
///   - username: The username of the account to be logged out.
///   - provider: The account provider of the account to be logged out.
/// - Returns: The logged-out user account.
/// - Throws: An error indicating issues with the logout process, such as an empty username or an account not found.
    func logout(username: String, provider: AccountProvider) -> Account {
            if (username.isEmpty) {
                print("Username should not be empty.")

            }
            let index = _accounts.firstIndex(where: {
                $0.username == username &&
                $0.provider == provider
            })
            if (index == nil) {
                print("Account not found.")
            }
            let account = _accounts[index!]
            var accountType: AccountType?
            _accounts.remove(at: index!)
            switch(provider){
            case .email(let emailEnum):
                accountType = .email(emailEnum)
                EmailService.logout(email: username)
                break
            }
        return account
        }
        
}
