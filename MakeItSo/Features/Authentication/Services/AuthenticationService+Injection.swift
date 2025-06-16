//
//  AuthenticationService+Injection.swift
//  MakeItSo
//
//  Created by Migovich on 16.06.2025.
//

import Foundation
import Factory

extension Container {
    public var authenticationService: Factory<AuthenticationService> {
        self { // self { } is a shortcut for calling Factory(self) { }
            AuthenticationService()
        }.singleton
    }
}
