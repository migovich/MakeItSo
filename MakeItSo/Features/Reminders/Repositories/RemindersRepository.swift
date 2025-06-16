//
//  RemindersRepository.swift
//  MakeItSo
//
//  Created by Migovich on 11.05.2025.
//

import Foundation
import Factory
import FirebaseFirestore
import FirebaseAuth
import Combine

public class RemindersRepository: ObservableObject {
    
    // MARK: Dependencies
    @Injected(\.firestore) var firestore
    @Injected(\.authenticationService) var authenticationService
    
    @Published var reminders = [Reminder]()
    @Published var user: User? = nil
    
    private var listenerRegistration: ListenerRegistration?
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        authenticationService.$user
            .assign(to: &$user)
        
        $user.sink { [weak self] user in
            self?.unsubscribe()
            self?.subscribe(user: user)
        }
        .store(in: &cancelables)
    }
    
    deinit {
        unsubscribe()
    }
    
    func subscribe(user: User? = nil) {
        guard listenerRegistration == nil else { return }
        guard let localUser = user ?? self.user else { return }
        let query = firestore.collection(Reminder.collectionName)
            .whereField("userId", isEqualTo: localUser.uid)
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
        var mutableReminder = reminder
        mutableReminder.userId = user?.uid
        
        try firestore
            .collection(Reminder.collectionName)
            .addDocument(from: mutableReminder)
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
