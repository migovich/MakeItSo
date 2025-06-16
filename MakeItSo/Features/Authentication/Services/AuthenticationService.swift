//
//  AuthenticationService.swift
//  MakeItSo
//
//  Created by Migovich on 16.06.2025.
//


import Foundation
import FirebaseAuth
import Factory

public class AuthenticationService {
    
    @Injected(\.auth) private var auth
    
    @Published var user: User?
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
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
