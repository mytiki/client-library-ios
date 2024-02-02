/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct AccountLogin: View {
    
    @State public var showAlert: Bool = false
    @State var username: String = ""
    @State var password: String = ""
    @State var errorMessage: String = ""
    
    var provider: EmailProviderEnum
    let onLogin: (Account) -> Void
    
    @FocusState private var usernameIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Email")
                .font(Rewards.theme.fontBold(size: 16))
                .foregroundColor(Rewards.theme.secondaryTextColor)
            TextField("", text: $username)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .foregroundColor(.black)
                .frame(height: 50)
                .font(Rewards.theme.fontBold(size: 20))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke())
                .padding(.top, 8)
                .focused($usernameIsFocused)
            Text("Password")
                .font(Rewards.theme.fontBold(size: 16))
                .foregroundColor(Rewards.theme.secondaryTextColor)
                .padding(.top, 32)
                .focused($passwordIsFocused)
            SecureField("", text: $password)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
                .foregroundColor(.black)
                .frame(height: 50)
                .font(Rewards.theme.fontBold(size: 16))
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke())
                .padding(.top, 8)
            Text("Sign in")
                    .foregroundColor(.white)
                    .font(Rewards.theme.fontMedium(size: 20))
                    .lineLimit(1)
                    .frame(height: 54)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    )
            .frame(maxWidth: .infinity)
            .background(Rewards.theme.accentColor)
                .cornerRadius(8)
                .padding(.top, 32)
                .alert("Error", isPresented: $showAlert) {
                } message: {
                    Button(errorMessage.isEmpty ? "Login Error." : errorMessage, role: .cancel) { }
                }
            .onTapGesture {
                    Task{

                    }
                }
        }
    }
}
