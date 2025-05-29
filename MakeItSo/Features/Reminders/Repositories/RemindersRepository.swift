//
//  RemindersRepository.swift
//  MakeItSo
//
//  Created by Migovich on 11.05.2025.
//

import Foundation
import Factory
import FirebaseFirestore

public class RemindersRepository: ObservableObject {
    
    // MARK: Dependencies
    @Injected(\.firestore) var firestore
    
    @Published var reminders = [Reminder]()
    
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        subscribe()
    }
    
    deinit {
        unsubscribe()
    }
    
    func subscribe() {
        guard listenerRegistration == nil else { return }
        let query = firestore.collection(Reminder.collectionName)
        listenerRegistration = query
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
        try firestore
            .collection(Reminder.collectionName)
            .addDocument(from: reminder)
    }
    
    func updateReminder(_ reminder: Reminder) throws {
        guard let documentId = reminder.id else {
            fatalError("Reminder \(reminder.title) has no document ID.")
        }
        try firestore
            .collection(Reminder.collectionName)
            .document(documentId)
            .setData(from: reminder, merge: true)
    }
    
    func removeReminder(_ reminder: Reminder) {
        guard let documentId = reminder.id else {
            fatalError("Reminder \(reminder.title) has no document ID.")
        }
        firestore
            .collection(Reminder.collectionName)
            .document(documentId)
            .delete()
    }
    
    private func unsubscribe() {
        guard listenerRegistration != nil else { return }
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
}
