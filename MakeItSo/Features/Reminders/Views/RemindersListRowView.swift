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
            Toggle(isOn: $reminder.isCompleted) {}
                .toggleStyle(.reminder)
            Text(reminder.title)
            Spacer()
        }
        .contentShape(Rectangle())
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
