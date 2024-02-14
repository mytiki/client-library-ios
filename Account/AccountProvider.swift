/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

public enum AccountProvider: Hashable{
    
    case retailer(RetailerEnum)
    case email(EmailProviderEnum)
    
    func name() -> String{
        var name = ""
        switch(self){
            case .email(let emailEnum) :
                name = emailEnum.rawValue
            case .retailer(let retailerEnum):
                name = retailerEnum.rawValue
        }
        return name.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    static func all() -> [AccountProvider] {
        var providers: [AccountProvider] = []
        EmailProviderEnum.allCases.forEach{ provider in
            providers.append(.email(provider))
        }
        RetailerEnum.allCases.forEach{ provider in
            providers.append(.retailer(provider))
        }
        return providers
    }
    
    public static func toAccountProvider(provider: String) -> AccountProvider? {
        if(provider == "GOOGLE"){
            return email(.google)
        }
        if(provider == "OUTLOOK"){
            return email(.outlook)
        }else{
            return email(.google)
        }
    }
}
