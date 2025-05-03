//
//  ContentView.swift
//  MakeItSo
//
//  Created by Migovich on 19.04.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var reminders = Reminder.samples
    @State private var isAddReminderPresented = false
    
    private func presendAddReminderView() {
        isAddReminderPresented.toggle()
    }
    
    var body: some View {
        List($reminders) { $reminder in
            HStack {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .onTapGesture {
                        reminder.isCompleted.toggle()
                    }
                Text(reminder.title)
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
                reminders.append(reminder)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .navigationTitle("Reminders")
    }
}
