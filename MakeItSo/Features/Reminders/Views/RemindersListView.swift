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
    @State private var editableReminder: Reminder? = nil
    @State private var isSettingsScreenPresented = false
    
    private func presendAddReminderView() {
        isAddReminderPresented.toggle()
    }
    
    private func presentSettingsScreen() {
        isSettingsScreenPresented.toggle()
    }
    
    var body: some View {
        List($viewModel.reminders) { $reminder in
            RemindersListRowView(reminder: $reminder)
                .onChange(of: reminder.isCompleted) { oldValue, newValue in
                    viewModel.setCompleted(reminder, isCompleted: newValue)
                }
                .onTapGesture {
                    editableReminder = reminder
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        viewModel.deleteReminder(reminder)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: presentSettingsScreen) {
                    Image(systemName: "gearshape")
                }
            }
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
            EditReminderDetailsView { reminder in
                viewModel.addReminder(reminder)
            }
        }
        .sheet(item: $editableReminder, content: { reminder in
            EditReminderDetailsView(mode: .edit, reminder: reminder) { reminder in
                viewModel.updateReminder(reminder)
            }
        })
        .sheet(isPresented: $isSettingsScreenPresented) {
            SettingsView()
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
