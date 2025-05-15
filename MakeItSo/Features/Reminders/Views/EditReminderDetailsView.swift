//
//  EditReminderDetailsView.swift
//  MakeItSo
//
//  Created by Migovich on 24.04.2025.
//

import SwiftUI

struct EditReminderDetailsView: View {
    enum FocusableField: Hashable {
        case title
    }

    @FocusState private var focusedField: FocusableField?
    
    enum Mode {
        case add
        case edit
    }
    
    var mode: Mode = .add
    
    @State var reminder = Reminder(title: "")
    
    @Environment(\.dismiss)
    private var dismiss
    
    var onCommit: (_ reminder: Reminder) -> Void
    
    private func commit() {
        onCommit(reminder)
        dismiss()
    }
    
    private func cancel() {
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $reminder.title)
                    .focused($focusedField, equals: .title)
            }
            .navigationTitle(mode == .add ? "New Reminder" : "Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: cancel) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: commit) {
                        Text(mode == .add ? "Add" : "Done")
                    }
                    .disabled(reminder.title.isEmpty)
                }
            }
            .onAppear {
                focusedField = .title
            }
        }
    }
}

#Preview("Add Reminder") {
    EditReminderDetailsView(mode: .add) { reminder in
        print("You added a new reminder: \(reminder.title)")
    }
}

#Preview("Edit Reminder") {
    @Previewable @State var reminder = Reminder.samples[0]
    EditReminderDetailsView(mode: .edit, reminder: reminder) { reminder in
        print("You edited a reminder: \(reminder.title)")
    }
}
