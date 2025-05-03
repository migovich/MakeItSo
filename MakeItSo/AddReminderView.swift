//
//  AddReminderView.swift
//  MakeItSo
//
//  Created by Migovich on 24.04.2025.
//

import SwiftUI

struct AddReminderView: View {
    @State private var reminder = Reminder(title: "")
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $reminder.title)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        print("Add button pressed")
                    }
                }
            }
        }
    }
}

#Preview {
    AddReminderView()
}
