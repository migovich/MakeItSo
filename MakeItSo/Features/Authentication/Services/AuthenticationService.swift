//
//  AuthenticationService.swift
//  MakeItSo
//
//  Created by Migovich on 16.06.2025.
//


import Foundation
import FirebaseAuth
import Factory
import AuthenticationServices

public class AuthenticationService {
    
    @Injected(\.auth) private var auth
    
    @Published var user: User?
    @Published var errorMessage: String?
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?
    
    init() {
        registerAuthStateHandler()
        signInAnonymously()
    }
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = auth.addStateDidChangeListener { [weak self] auth, user in
                // will be called whenever the authentication state changes
                self?.user = user
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            signInAnonymously()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            signOut()
            return true
        } catch {
            print("Error deleting user: \(error.localizedDescription)")
            return false
        }
    }
}

// MARK: - Sing in anonymously

extension AuthenticationService {
    func signInAnonymously() {
        if auth.currentUser == nil {
            print("Nobody is signed in. Trying to sign in anonymously.")
            auth.signInAnonymously()
        } else if let user = auth.currentUser {
            print("Someone is signed in with \(user.providerID) and user ID \(user.uid)")
        }
    }
}

// MARK: - Sign in with Apple

extension AuthenticationService {
    @MainActor
    func handleSignInWithAppleCompletion(withAccountLinking: Bool = false, _ result: Result<ASAuthorization, Error>) async -> Bool {
        switch result {
        case .success(let authorization):
            if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIdToken = appleIdCredential.identityToken else {
                    print("Unable to fetch identify token.")
                    return false
                }
                guard let appleIdTokenString = String(data: appleIdToken, encoding: .utf8) else {
                    print("Unable to convert Apple ID token to string.")
                    return false
                }
                let credential = OAuthProvider.appleCredential(withIDToken: appleIdTokenString,
                                                               rawNonce: nonce,
                                                               fullName: appleIdCredential.fullName)
                do {
                    if withAccountLinking {
                        let authResult = try await user?.link(with: credential)
                        user = authResult?.user
                    } else {
                        try await auth.signIn(with: credential)
                    }
                    return true
                } catch {
                    print("Error authenticating: \(error.localizedDescription)")
                    return false
                }
            }
            return true
        case .failure(let error):
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        do {
            let nonce = try CryptoUtils.randomNonceString() // A nonce is a one-time code that can be used to add an additional layer of security to the sign-in flow
            currentNonce = nonce
            request.nonce = CryptoUtils.sha256(nonce)
        } catch {
            print("Error when creating a nonce: \(error.localizedDescription)")
        }
    }
}
