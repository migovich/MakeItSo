//
//  RemindersListRowView.swift
//  MakeItSo
//
//  Created by Migovich on 03.05.2025.
//

import SwiftUI

struct RemindersListRowView: View {
    @Binding var reminder: Reminder
    
    var body: some View {
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
}

#Preview {
    NavigationView {
        List {
            StatefulPreviewWrapper(Reminder.samples[0]) { reminder in
                RemindersListRowView(reminder: reminder)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Reminders")
    }
}
