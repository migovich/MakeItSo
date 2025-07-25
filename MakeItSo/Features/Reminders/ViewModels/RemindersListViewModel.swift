//
//  RemindersListViewModel.swift
//  MakeItSo
//
//  Created by Migovich on 03.05.2025.
//

import Foundation
import Factory
import Combine

class RemindersListViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    @Published var errorMessage: String?
    
    // MARK: Dependencies
    @Injected(\.remindersRepository)
    private var remindersRepository: RemindersRepository
    
    init() {
        remindersRepository
            .$reminders
            .assign(to: &$reminders)
    }
    
    func addReminder(_ reminder: Reminder) {
        do {
            try remindersRepository.addReminder(reminder)
            errorMessage = nil
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func updateReminder(_ reminder: Reminder) {
        do {
            try remindersRepository.updateReminder(reminder)
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteReminder(_ reminder: Reminder) {
        remindersRepository.removeReminder(reminder)
    }
    
    func setCompleted(_ reminder: Reminder, isCompleted: Bool) {
        var editedReminder = reminder
        editedReminder.isCompleted = isCompleted
        updateReminder(editedReminder)
    }
}
