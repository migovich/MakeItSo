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
    StatefulPreviewWrapper(Reminder.samples[0]) { reminder in
        RemindersListRowView(reminder: reminder)
    }
}
