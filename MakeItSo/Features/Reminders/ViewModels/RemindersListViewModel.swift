//
//  RemindersListViewModel.swift
//  MakeItSo
//
//  Created by Migovich on 03.05.2025.
//

import Foundation

class RemindersListViewModel: ObservableObject {
    @Published var reminders = Reminder.samples
    
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
    }
    
    func toggleCompleted(_ reminder: Reminder) {
        guard let index = reminders.firstIndex(where: { $0.id == reminder.id }) else { return }
        reminders[index].isCompleted.toggle()
    }
}
