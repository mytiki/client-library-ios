/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import SwiftUI

public struct OfferLinkCardView: View {
    public init() {}
    let a = Image("tikilogo.png")
    public var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#01CB82"), Color(hex: "#00B272"), Color(hex: "#026A44")]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea() // Ignore just for the color
            .background()
            .overlay(
                VStack(alignment: .leading) {
                    image("tikilogo")
                    Text("Share your purchase")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                    Text("history:")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.top, -30)

                    HStack(){
                        Spacer()
                        ZStack(){
                            Circle()
                                .fill(Color.white.opacity(0))
                                .frame(width: 150, height: 150)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.white, lineWidth: 7)
                            )
                            VStack(alignment: .center){
                                HStack(alignment: .bottom) {
                                    Spacer()
                                    Text("100")
                                        .fontWeight(.medium)
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                        .padding(.trailing, -8)
                                        .padding(.top, 10)
                                    Text("pts")
                                        .fontWeight(.medium)
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                        .padding(.top, -35)
                                    Spacer()
                                }
                                HStack(){
                                    Text("each month")
                                        .fontWeight(.medium)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                        }

                        Spacer()
                    }.padding(.top, 5)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("We use your data for:")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.top, 35)
                        HStack(){
                            Image(systemName: "slider.vertical.3")
                                .foregroundColor(.white)
                            Text("Aggregate market insights")
                                .fontWeight(.medium)
                                .font(.system(size: 21))
                                .foregroundColor(.white)
                        }
                        HStack(){
                            Image(systemName: "percent")
                                .foregroundColor(.white)
                            Text("Exclusive offers just for you")
                                .fontWeight(.medium)
                                .font(.system(size: 21))
                                .foregroundColor(.white)
                        }
                        HStack() {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.white)
                            Text("Improving systems like AI")
                                .fontWeight(.medium)
                                .font(.system(size: 21))
                                .foregroundColor(.white)                        }
                        Text("Learn more or change your mind any time in settings.")
                            .fontWeight(.medium)
                            .font(.system(size: 21))
                            .foregroundColor(.white)
                    }.padding(.horizontal, 40).padding(.bottom, 40)

                    VStack(){
                        Button() {
                            TikiClient.acceptOffer(completion: {response in print(response)}, onError: {error in print(error)})
                        } label: {
                            Text("Link Card")
                                .font(.system(size: 21))
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color(hex: "#026A44"))
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(50)
                        }.buttonStyle(.plain).padding(.bottom, 10)
                        Button() {
                            TikiClient.denyOffer(offer: TikiClient.offer!,completion: {response in print(response)}, onError: {error in print(error)})
                        } label: {
                            Text("No Thanks")
                                .font(.system(size: 21))
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(.green).opacity(0))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.white, lineWidth: 4)
                            )

                                
                        }.buttonStyle(.plain)
                    }.padding(.horizontal, 40)
                }
            )
    }
}

func image(_ name: String) -> Image? {
    let bundle = Bundle(for: TikiClient.self)
    guard let path = bundle.path(forResource: "Assets/\(name)", ofType: "png") else {
        print("image not found")
        return nil
    }
    let image = Image("tikilogo.png", bundle: bundle)
    return Image(path)

}
