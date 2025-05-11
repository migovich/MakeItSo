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
    
    func subscribe() {
        let query = Firestore.firestore().collection("reminders")
        query
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                print("Mapping \(documents.count) documents")
                self?.reminders = documents.compactMap { queryDocumentSnapshot in
                    do {
                        return try queryDocumentSnapshot.data(as: Reminder.self)
                    } catch {
                        print("Error while trying to map document \(queryDocumentSnapshot.documentID): \(error.localizedDescription)")
                        return nil
                    }
                }
            }
    }
    
    func addReminder(_ reminder: Reminder) throws {
        try Firestore
            .firestore()
            .collection("reminders")
            .addDocument(from: reminder)
    }
}
