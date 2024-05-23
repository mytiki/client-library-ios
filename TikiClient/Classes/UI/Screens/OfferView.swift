//
//  OfferView.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 21/05/24.
//

import SwiftUI

public struct OfferView: View {
    public init() {}
    let a = image("tikilogo.png")
    public var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#01CB82"), Color(hex: "#00B272"), Color(hex: "#026A44")]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea() // Ignore just for the color
            .background()
            .overlay(
                VStack(alignment: .leading) {
                    Text("Share your purchase history:")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.trailing, 85)
                        .padding(.leading, 54)
                        .padding(.top, 86)

                    HStack(){
                        Spacer()
                        ZStack(){
                            Circle()
                                .fill(Color.white.opacity(0))
                                .frame(width: 200, height: 200)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.white, lineWidth: 8)
                            )
                            VStack(){
                                HStack(alignment: .bottom) {
                                    Spacer()
                                    Text("100")
                                        .fontWeight(.medium)
                                        .font(.system(size: 75))
                                        .foregroundColor(.white)
                                    Text("pts")
                                        .fontWeight(.medium)
                                        .font(.system(size: 33))
                                        .foregroundColor(.white)
                                        .padding(.top, -50)
                                    Spacer()
                                }
                                HStack(){
                                    Text("each month")
                                        .fontWeight(.medium)
                                        .font(.system(size: 23))
                                        .foregroundColor(.white)
                                }
                            }
                        }

                        Spacer()
                    }

                    Spacer()
                    Text("We use your data for:").font(.headline).foregroundColor(.white)
                    Text("Aggregate market insights").font(.subheadline).foregroundColor(.white)
                    Text("Exclusive offers just for you").font(.subheadline).foregroundColor(.white)
                    Text("Improving systems like AI").font(.subheadline).foregroundColor(.white)
                    Text("Learn more or change your mind any time in settings.").font(.headline).foregroundColor(.white)
                    Button() {
                        print("Linked card")
                    } label: {
                        Text("Link Card")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(hex: "#026A44"))
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(50)
                    }.buttonStyle(.plain)
                    Button() {
                        print("No Thanks")
                    } label: {
                        Text("No Thanks")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .padding()
                            .background(Color(.green).opacity(0))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 2)
                        )

                            
                    }.buttonStyle(.plain)
                }
            )
    }
}

func image(_ name: String) -> UIImage? {
    let podBundle = Bundle(for: TikiClient.self) // for getting pod url
    if let url = podBundle.url(forResource: "TikiClientAssets", withExtension: "bundle") { //<YourBundleName> must be the same as you wrote in .podspec
        let bundle = Bundle(url: url)
        let imageee = UIImage(named: name, in: bundle, compatibleWith: nil)
        return imageee
    }
    return UIImage()
}
