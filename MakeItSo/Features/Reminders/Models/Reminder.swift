//
//  Reminder.swift
//  MakeItSo
//
//  Created by Migovich on 19.04.2025.
//

import Foundation
import FirebaseFirestore

struct Reminder: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var isCompleted: Bool = false
}

extension Reminder {
    static let samples: [Reminder] = [
        .init(title: "Make it so", isCompleted: true),
        .init(title: "Make it so again"),
        .init(title: "Make it so once more"),
    ]
}

extension Reminder {
    static let collectionName = "reminders"
}
