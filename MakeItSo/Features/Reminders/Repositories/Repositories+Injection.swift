//
//  Repositories+Injection.swift
//  MakeItSo
//
//  Created by Migovich on 15.05.2025.
//

import Foundation
import Factory

extension Container {
    
    public var remindersRepository: Factory<RemindersRepository> {
        self {
            RemindersRepository()
        }.singleton
    }
}
