//
// SettingsViewModel.swift
// MakeItSo
//
//  Created by Migovich on 15.06.2025.
//

import Foundation
import Factory
import FirebaseAuth
import Combine

class SettingsViewModel: ObservableObject {
    @Published var user: User?
    @Published var displayName = ""
    
    @Published var isGuestUser = false
    
    @Published var loggedInAs = ""
    
    init() {
        $user
            .compactMap { user in
                user?.isAnonymous
            }
            .assign(to: &$isGuestUser)
        
        $user
            .compactMap { user in
                user?.displayName ?? user?.email ?? ""
            }
            .assign(to: &$displayName)
        
        Publishers.CombineLatest($isGuestUser, $displayName)
            .map { isGuest, displayName in
                isGuest
                ? "You're using the app as a guest"
                : "Logged in as \(displayName)"
            }
            .assign(to: &$loggedInAs)
    }
    
    func signOut() {
        fatalError("Not implemented yet")
    }
}
