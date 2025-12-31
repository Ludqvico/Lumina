//
//  Task.swift
//  TaskManager
//
//  Created by Lumina on 2025
//

import Foundation

struct Task: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var priority: Priority
    var dueDate: Date?
    var createdDate: Date

    enum Priority: String, Codable, CaseIterable {
        case low = "Bassa"
        case medium = "Media"
        case high = "Alta"

        var color: String {
            switch self {
            case .low: return "green"
            case .medium: return "orange"
            case .high: return "red"
            }
        }
    }

    init(id: UUID = UUID(),
         title: String,
         description: String = "",
         isCompleted: Bool = false,
         priority: Priority = .medium,
         dueDate: Date? = nil,
         createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.priority = priority
        self.dueDate = dueDate
        self.createdDate = createdDate
    }
}

// Sample data for preview
extension Task {
    static var sampleTasks: [Task] {
        [
            Task(title: "Completare il progetto", description: "Finire la presentazione per la riunione", priority: .high, dueDate: Date().addingTimeInterval(86400)),
            Task(title: "Fare la spesa", description: "Comprare latte, pane e uova", priority: .medium),
            Task(title: "Leggere un libro", description: "Continuare la lettura del romanzo", isCompleted: true, priority: .low),
            Task(title: "Palestra", description: "Allenamento cardio 30 minuti", priority: .medium, dueDate: Date())
        ]
    }
}
