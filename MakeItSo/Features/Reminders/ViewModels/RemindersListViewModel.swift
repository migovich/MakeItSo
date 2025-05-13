//
//  RemindersListViewModel.swift
//  MakeItSo
//
//  Created by Migovich on 03.05.2025.
//

import Foundation
import Combine

class RemindersListViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    @Published var errorMessage: String?
    
    private var remindersRepository = RemindersRepository()
    
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
    
    func setCompleted(_ reminder: Reminder, isCompleted: Bool) {
        var editedReminder = reminder
        editedReminder.isCompleted = isCompleted
        updateReminder(editedReminder)
    }
    
//    func toggleCompleted(_ reminder: Reminder) {
//        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
//        reminders[index].isCompleted.toggle()
//    }
}
