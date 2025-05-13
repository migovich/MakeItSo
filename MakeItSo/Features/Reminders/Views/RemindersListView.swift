//
//  RemindersListView.swift
//  MakeItSo
//
//  Created by Migovich on 19.04.2025.
//

import SwiftUI

struct RemindersListView: View {
    
    @StateObject private var viewModel = RemindersListViewModel()
    @State private var isAddReminderPresented = false
    
    private func presendAddReminderView() {
        isAddReminderPresented.toggle()
    }
    
    var body: some View {
        List($viewModel.reminders) { $reminder in
            RemindersListRowView(reminder: $reminder)
                .onChange(of: reminder.isCompleted) { oldValue, newValue in
                    viewModel.setCompleted(reminder, isCompleted: newValue)
                }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: presendAddReminderView) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Reminder")
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $isAddReminderPresented) {
            AddReminderView { reminder in
                viewModel.addReminder(reminder)
            }
        }
        .tint(.red)
    }
}

#Preview {
    NavigationStack {
        RemindersListView()
            .navigationTitle("Reminders")
    }
}
