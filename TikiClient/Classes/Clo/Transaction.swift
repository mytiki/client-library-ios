import Foundation

/// Data structure representing a transaction for CLO matching.
public struct Transaction {

    /// Transaction amount.
    public let amount: Int

    /// Transaction status.
    public let status: TransactionStatusEnum

    /// Currency of the transaction.
    public let currency: String

    /// Transaction description.
    public let description: String

    /// Additional transaction description.
    public let description2: String

    /// Merchant category code (MCC).
    public let mcc: String

    /// Transaction date.
    public let transactionDate: Date

    /// Merchant ID.
    public let merchantId: String

    /// Merchant store ID (optional).
    public let merchantStoreId: String?

    /// Merchant name.
    public let merchantName: String

    /// Merchant address city.
    public let merchantAddrCity: String

    /// Merchant address state.
    public let merchantAddrState: String

    /// Merchant address ZIP code.
    public let merchantAddrZipcode: String

    /// Merchant address country.
    public let merchantAddrCountry: String

    /// Merchant address street.
    public let merchantAddrStreet: String

    /// Card Bank Identification Number (BIN).
    public let cardBIN: String

    /// Last four digits of the card.
    public let cardLastFour: String

    /// Initializes a new instance of `Transaction`.
    ///
    /// - Parameters:
    ///   - amount: Transaction amount.
    ///   - status: Transaction status.
    ///   - currency: Currency of the transaction.
    ///   - description: Transaction description.
    ///   - description2: Additional transaction description.
    ///   - mcc: Merchant category code (MCC).
    ///   - transactionDate: Transaction date.
    ///   - merchantId: Merchant ID.
    ///   - merchantStoreId: Merchant store ID (optional).
    ///   - merchantName: Merchant name.
    ///   - merchantAddrCity: Merchant address city.
    ///   - merchantAddrState: Merchant address state.
    ///   - merchantAddrZipcode: Merchant address ZIP code.
    ///   - merchantAddrCountry: Merchant address country.
    ///   - merchantAddrStreet: Merchant address street.
    ///   - cardBIN: Card Bank Identification Number (BIN).
    ///   - cardLastFour: Last four digits of the card.
    public init(
        amount: Int,
        status: TransactionStatusEnum,
        currency: String,
        description: String,
        description2: String,
        mcc: String,
        transactionDate: Date,
        merchantId: String,
        merchantStoreId: String?,
        merchantName: String,
        merchantAddrCity: String,
        merchantAddrState: String,
        merchantAddrZipcode: String,
        merchantAddrCountry: String,
        merchantAddrStreet: String,
        cardBIN: String,
        cardLastFour: String
    ) {
        self.amount = amount
        self.status = status
        self.currency = currency
        self.description = description
        self.description2 = description2
        self.mcc = mcc
        self.transactionDate = transactionDate
        self.merchantId = merchantId
        self.merchantStoreId = merchantStoreId
        self.merchantName = merchantName
        self.merchantAddrCity = merchantAddrCity
        self.merchantAddrState = merchantAddrState
        self.merchantAddrZipcode = merchantAddrZipcode
        self.merchantAddrCountry = merchantAddrCountry
        self.merchantAddrStreet = merchantAddrStreet
        self.cardBIN = cardBIN
        self.cardLastFour = cardLastFour
    }
}
