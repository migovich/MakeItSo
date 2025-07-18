//
// SignupView.swift
// MakeItSo
//
//  Created by Migovich on 15.06.2025.
//

import SwiftUI
import Combine
import AuthenticationServices
import FirebaseAnalytics

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}

struct SignupView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusableField?
    
    var emailPasswordSignInArea: some View {
        VStack {
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $viewModel.password)
                    .focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        // sign up with email and password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Confirm password", text: $viewModel.confirmPassword)
                    .focused($focus, equals: .confirmPassword)
                    .submitLabel(.go)
                    .onSubmit {
                        // sign up with email and password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            if !viewModel.errorMessage.isEmpty {
                VStack {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
            }
            
            Button(action: { /* sign up with email and password */ } ) {
                if viewModel.authenticationState != .authenticating {
                    Text("Sign up")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(!viewModel.isValid)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(colorScheme == .light ? "logo-light" : "logo-dark")
                    .resizable()
                    .frame(width: 30, height: 30 , alignment: .center)
                    .cornerRadius(8)
                Text("Make It So")
                    .font(.title)
                    .bold()
            }
            .padding(.horizontal)
            
            VStack {
                Image(colorScheme == .light ? "auth-hero-light" : "auth-hero-dark")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .padding(.vertical, 24)
                
                Text("Get your work done. Make it so.")
                    .font(.title2)
                    .padding(.bottom, 16)
            }
            
            Spacer()
            
            GoogleSignInButton(.signUp) {
                Task {
                    if let viewController = UIApplication.rootViewController {
                        if await viewModel.handleSignInWithGoogle(presentingViewController: viewController) {
                            dismiss()
                        }
                    }
                }
            }
            
            SignInWithAppleButton(.signUp) { request in
                viewModel.handleSignInWithAppleRequest(request)
            } onCompletion: { result in
                Task {
                    if await viewModel.handleSignInWithAppleCompletion(result) {
                        dismiss()
                    }
                }
            }
            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            .cornerRadius(8)
            
            Button(action: {
                withAnimation {
                    viewModel.isOtherAuthOptionsVisible.toggle()
                }
            }) {
                Text("More sign-in options")
                    .underline()
            }
            .buttonStyle(.plain)
            .padding(.top, 16)
            
            if viewModel.isOtherAuthOptionsVisible {
                emailPasswordSignInArea
            }
            
            HStack {
                Text("Already have an account?")
                Button(action: { viewModel.switchFlow() }) {
                    Text("Log in")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 8)
        }
        .padding()
        .analyticsScreen(name: "\(Self.self)")
    }
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignupView()
            SignupView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(AuthenticationViewModel())
    }
}
