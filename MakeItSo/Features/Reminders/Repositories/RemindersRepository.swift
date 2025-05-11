//
//  RemindersRepository.swift
//  MakeItSo
//
//  Created by Migovich on 11.05.2025.
//

import Foundation
import FirebaseFirestore

public class RemindersRepository: ObservableObject {
    
    @Published var reminders = [Reminder]()
    
    func addReminder(_ reminder: Reminder) throws {
        try Firestore
            .firestore()
            .collection("reminders")
            .addDocument(from: reminder)
    }
}
