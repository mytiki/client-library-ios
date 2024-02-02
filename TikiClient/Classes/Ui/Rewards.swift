/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation
import SwiftUI
import TikiSdk
import AppAuth

/// # Rewards
///
/// The `Rewards` class is the main API to interact with TIKI Rewards program.
///
/// ## Overview
///
/// The Rewards class works as a singleton and initializes the services for:
/// - theming: `Theme`
/// - 3rd party account management: `AccountService`
/// - capture user data: `CaptureService`
/// - data license handling: `LicenseService`
///
/// ## Example
///
/// To get started with the rewards system, use the following example:
///
/// ```swift
/// // Start rewards system with default theme
/// Rewards.start()
///
/// // Start rewards system with a custom theme
/// ```
///   Rewards.start(Theme(
///     primaryTextColor: <Color>,
///     secondaryTextColor: <Color>,
///     primaryBackgroundColor: <Color>,
///     secondaryBackgroundColor: <Color>,
///     accentColor: <Color>,
///     fontFamily: <Font Family>))
/// ```
///
public class Rewards{
    
    /// The current theme.
    public static var theme: Theme = Theme()
    
    /// An instance of `AccountService` for managing 3rd party accounts.
    public static let account = Account(username: "test", provider: .google)
    
    /// An instance of `CaptureService` for handling data capture functionalities.
    public static var capture = CaptureService.init()
    
    /// An instance of `LicenseService` for managing data licenses.
    public static let license = LicenseService()
    
    /// An instance of `CardService` for managing card service.
//    public static let card = CardService()
    
    /// An instance of `Configuration` for receive the configuration.
    public static var configuration: Configuration? = nil

    /// An instance of `Company` for receive the company informations.
    public static var company: Company? = nil
    
    /// An instance of UIViewController.
    public static var rootViewController: UIViewController? = nil
    
    
    /// Initializes the rewards system and presents the home screen.
    ///
    /// - Parameters:
    ///    - `theme`: An optional parameter to set a custom theme. If not provided, the default theme is used.
    ///
    /// The home screen is presented modally with a cross-dissolve transition and a semi-transparent background.
    public static func show(_ theme: Theme? = nil, userId: String) throws {
        self.theme = theme ?? self.theme
        if(configuration == nil){
            throw NSError()
        }
        Task(priority: .high){

            DispatchQueue.main.async{
                rootViewController = UIApplication.shared.keyWindowPresentedController
                let vc = UIHostingController(
                    rootView: HomeScreen(onDismiss: { rootViewController?.dismiss(animated: true) })
                )
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.3).cgColor
                rootViewController!.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    /// Configures the Capture Receipt SDK with the necessary parameters.
    ///
    /// - Parameters:
    ///   - tikiPublishingID: The TIKI publishing ID.
    ///   - microblinkLicenseKey: The Microblink license key.
    ///   - productIntelligenceKey: The product intelligence key.
    ///   - terms: The terms associated with the license.
    ///   - gmailAPIKey: The API key for Gmail (optional).
    ///   - outlookAPIKey: The API key for Outlook (optional).
    public static func config(
        terms: String,
        clientId: String,
        clientSecret: String,
        primaryTextColor: Color? = nil,
        secondaryTextColor: Color? = nil,
        primaryBackgroundColor: Color? = nil,
        secondaryBackgroundColor: Color? = nil,
        accentColor: Color? = nil,
        fontFamily: String? = nil
    ){
        self.configuration = Configuration(
            terms: terms,
            clientId: clientId
        )
        if(primaryTextColor != nil && secondaryTextColor != nil && primaryTextColor != nil && secondaryTextColor != nil && accentColor != nil && fontFamily != nil){
            theme(primaryTextColor: primaryTextColor!, secondaryTextColor: secondaryTextColor!, primaryBackgroundColor: primaryBackgroundColor!, secondaryBackgroundColor: secondaryBackgroundColor!, accentColor: accentColor!, fontFamily: fontFamily!)
        }
        LicenseService.setTerms(terms: terms)
    }
    
    /// Configure the Company.
    ///
    /// - Parameters:
    ///   - name: Company name.
    ///   - jurisdiction: Company's place of operation.
    ///   - privacy: Company's privacy policy.
    ///   - terms: Company's terms.
    public static func company(name: String, jurisdiction: String, privacy: String, terms: String) {
        company = Company(name: name, jurisdiction: jurisdiction, privacy: privacy, terms: terms)
        LicenseService.setTerms(terms: name+jurisdiction+privacy+terms)
    }
    
    
    
    /// Configuration the Rewards themes.
    ///
    /// - Parameters:
    ///   - primaryTextColor: The primary text color of the theme.
    ///   - secondaryTextColor: The secondary text color of the theme.
    ///   - primaryBackgroundColor: The primary background color of the theme.
    ///   - secondaryBackgroundColor: The secondary background color of the theme.
    ///   - accentColor: The accent color.
    ///   - fontFamily: The font family of the theme.
    public static func theme(primaryTextColor: Color,
                                secondaryTextColor: Color,
                                primaryBackgroundColor: Color,
                                secondaryBackgroundColor: Color,
                                accentColor: Color,
                                fontFamily: String){
        self.theme = Theme(primaryTextColor: primaryTextColor, secondaryTextColor: secondaryTextColor, primaryBackgroundColor: primaryBackgroundColor, secondaryBackgroundColor: secondaryBackgroundColor, accentColor: accentColor, fontFamily: fontFamily)
        
    }
    
    /// Retrieves a list of the largest contributors to the rewards program.
    ///
    /// - Returns: An array of `MoreContributor` objects containing contributor details.
    static func largestContributors() -> [MoreContributor] {
        return [
            MoreContributor(name: "Walmart", percentage: 0.4),
            MoreContributor(name: "Kroger", percentage: 0.3),
            MoreContributor(name: "Dollar General", percentage: 0.2)
        ]
    }
    
}
