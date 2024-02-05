/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct HomeScreen: View {
    
    let onDismiss: () -> Void
    @State var isLicensed: Bool = Rewards.license.isLicensed()
    
    
    var body: some View {
        if(isLicensed){
            HomeView(onDismiss: onDismiss, onLicenseDeclined: {
                Rewards.license.decline()
                isLicensed = Rewards.license.isLicensed()
            })
        }
        if(!isLicensed){
            LicenseView(onDismiss: onDismiss, onLicenseAccepted: {
                Rewards.license.accept()
                isLicensed = Rewards.license.isLicensed()
            })
        }

    }
}
