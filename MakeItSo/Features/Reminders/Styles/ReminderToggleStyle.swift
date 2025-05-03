//
//  ReminderToggleStyle.swift
//  MakeItSo
//
//  Created by Migovich on 03.05.2025.
//

import SwiftUI

struct ReminderToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(configuration.isOn ? Color.accentColor : Color.gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

extension ToggleStyle where Self == ReminderToggleStyle {
    static var reminder: ReminderToggleStyle {
        ReminderToggleStyle()
    }
}

#Preview {
    StatefulPreviewWrapper(true) { value in
        Toggle(isOn: value) { Text("Hello") }
            .toggleStyle(.reminder)
    }
}
