/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI
import Foundation

public struct LicenseView: View {
    
    let onDismiss: () -> Void
    let onLicenseAccepted: () -> Void
    @State var showSheet: Bool = true
    @State var offset: CGFloat = 0
    @State var showTerms: Bool = false

    public var body: some View {
        if(showSheet){
            ZStack{
                VStack(alignment: .center) {
                    BottomSheetHeader(
                        title: "CASHBACK CONNECTIONS",
                        subtitle: "Share data. Earn cash.",
                        close: {
                            showSheet = false
                            onDismiss()
                        })
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    LicenseCard()
                        .padding(.horizontal, 15)
                        .padding(.top, 48)
                    Text("Estimate based on similar users spending habits and market price for shopping data.")
                        .font(Rewards.theme.fontMedium(size: 14))
                        .foregroundColor(Rewards.theme.secondaryTextColor)
                        .padding(.horizontal, 15)
                        .padding(.top, 36)
                    Button (action: {
                        showTerms = true
                    }, label: {
                        Text("Get estimate")
                            .foregroundColor(.white)
                            .font(Rewards.theme.fontMedium(size: 20))
                            .lineLimit(1)
                            .frame(width: 360, height: 54)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            )
                    })
                    .background(Color.tikiGreen)
                    .cornerRadius(8)
                    .padding(.horizontal, 15)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .transition(.bottomSheet)
                .background(.white)
                .asBottomSheet(
                    isShowing: $showSheet,
                    offset: $offset,
                    onDismiss: {
                        showSheet = false
                        onDismiss()
                    }
                )
                if(showTerms){
                    LicenseTerms(showTerms: $showTerms, onLicenseAccepted: onLicenseAccepted)
                        .transition(.navigate)
                }
            }
        }
    }
}
