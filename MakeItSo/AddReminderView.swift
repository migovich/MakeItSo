//
//  AddReminderView.swift
//  MakeItSo
//
//  Created by Migovich on 24.04.2025.
//

import SwiftUI

struct AddReminderView: View {
    @State private var reminder = Reminder(title: "")
    
    @Environment(\.dismiss)
    private var dismiss
    
    var onCommit: (_ reminder: Reminder) -> Void
    
    private func commit() {
        onCommit(reminder)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $reminder.title)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: commit) {
                        Text("Add")
                    }
                }
            }
        }
    }
}

#Preview {
    AddReminderView { reminder in
        print("You added a new reminder: \(reminder.title)")
    }
}
