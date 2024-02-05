/*
 * AccountTypeEnum Enum
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */
import Foundation

/// An enumeration representing different types of user accounts.
public enum AccountType {
    case retailer(RetailerEnum)
    case email(EmailProviderEnum)
}
