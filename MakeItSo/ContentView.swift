//
//  ContentView.swift
//  MakeItSo
//
//  Created by Migovich on 19.04.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var reminders = Reminder.samples
    
    var body: some View {
        List(reminders) { reminder in
            HStack {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(reminder.title)
            }
        }
    }
}

#Preview {
    ContentView()
}
