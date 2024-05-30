/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import SwiftUI

public struct OfferAllowTrackView: View {
    public init() {}
    public var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#01CB82"), Color(hex: "#00B272"), Color(hex: "#026A44")]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea() // Ignore just for the color
            .background()
            .overlay(
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Allow tracking on the next screen for:")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.top, -35)

                    VStack(alignment: .leading, spacing: 45){
                        HStack(){
                            Image(systemName: "gift.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.trailing, 10)
                                .foregroundColor(.white)
                            Text("Data offers and promotions just for you")
                                .fontWeight(.semibold)
                                .font(.system(size: 21))
                                .foregroundColor(.white)
                        }
                        HStack(){
                            Image(systemName: "hand.tap.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.trailing, 10)
                                .foregroundColor(.white)

                            Text("Advertisements that match your interests")
                                .fontWeight(.semibold)
                                .font(.system(size: 21))
                                .foregroundColor(.white)
                        }
                        HStack() {
                            Image(systemName: "person.badge.shield.checkmark.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.trailing, 10)
                                .foregroundColor(.white)
                            Text("An improved personalized experience over time")
                                .fontWeight(.semibold)
                                .font(.system(size: 21))
                                .foregroundColor(.white)                        }
                        Text("You can change this option later in the Settings app.")
                            .fontWeight(.semibold)
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }.padding(.horizontal, 40).padding(.vertical, 30)

                    VStack(){
                        Button() {
                            TikiClient.tracking.askToTrack(completion: {status in
                                switch status {
                                case .notDetermined:
                                    print("not determined")
                                    break
                                case .restricted:
                                    print("restricted")
                                case .denied:
                                    OfferFlow.step.offerFollowSteps = .permissions
                                case .authorized:
                                    OfferFlow.step.offerFollowSteps = .offers
                                default:
                                    OfferFlow.step.offerFollowSteps = .permissions
                                }
                                })
                        } label: {
                            Text("Continue")
                                .font(.system(size: 23))
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color(hex: "#026A44"))
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(50)
                        }.buttonStyle(.plain).padding(.bottom, 10)
                    }.padding(.horizontal, 40)
                    Spacer()
                }
            )
    }
}
