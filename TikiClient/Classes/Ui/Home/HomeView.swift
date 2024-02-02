/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI
import Foundation

public struct HomeView: View {
    
    let onDismiss: () -> Void
    let onLicenseDeclined: () -> Void
    @State var showSheet: Bool = true
    @State var showMoreSheet: Bool = false
    @State var showAccountSheet: Bool = false
    @State var offset: CGFloat = 0
    @State var providers: [EmailProviderEnum]
    @State var provider: EmailProviderEnum? = nil
    @State var isOpen: Bool = false
    
    func onProvider(provider: EmailProviderEnum) -> Void{
        self.provider = provider
        self.showAccountSheet = true
    }
    
    public var body: some View {
        ZStack(){
            if(showSheet){
                VStack(alignment: .center, spacing: 0) {
                  if(isOpen){
                        ScreenHeader(title: "Increase Earnings", action: { isOpen = false })
                            .padding(.top, isOpen ? 24 : 0)
                            .font(SpaceGrotesk.medium(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 48)
                            .padding(.bottom, 24)
                  }else{
                        BottomSheetHeader(
                            title: "CASHBACK CONNECTIONS",
                            subtitle: "Share data. Earn cash.",
                            close: {
                                showSheet = false
                                onDismiss()
                            })
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        HomeCard(showMoreSheet: $showMoreSheet)
                            .padding(.top, 48)
                            .padding(.horizontal, 24)
                        Text ("Increase Earnings")
                          .padding(.top, isOpen ? 24 : 0)
                          .font(SpaceGrotesk.medium(size: 16))
                          .frame(maxWidth: .infinity, alignment: .leading)
                          .padding(.horizontal, 24)
                          .padding(.top, 48)
                          .padding(.bottom, 24)
                    }
                    if(isOpen){
                        HomeGrid(isOpen: $isOpen, providers: providers)
                    }else{
                        HomeCarousel(providers: providers)
                    }
                }
                .padding(.bottom, isOpen ? 0 : 40)
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
                .gesture(DragGesture(minimumDistance: 5, coordinateSpace: .global)
                    .onChanged { value in
                        if(!isOpen){
                            offset = value.translation.height > 0 ? value.translation.height : 0
                        }
                    }
                    .onEnded{ value in
                        if(isOpen){
                            if(value.translation.height > 0){
                                isOpen = false
                            }
                        }else{
                            if(value.translation.height > 0){
                                withAnimation(.easeOut) {
                                    showSheet = false
                                }
                                onDismiss()
                            }else{
                                isOpen = true
                            }
                        }
                    }
                )
            }
            if(showMoreSheet){
                MoreView(showMoreSheet: $showMoreSheet, onLicenseDeclined: onLicenseDeclined)
            }
            
            if(showAccountSheet){
                EmailView(provider: provider!, showAccountSheet: $showAccountSheet, onAccount: removeProvider)

            }
        }
    }
    
    func removeProvider(_ account: Account){
        let rmProvider = account.provider
        providers.removeAll{ prov in prov == rmProvider}
    }
}
