//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Lumina on 2025
//

import SwiftUI

@main
struct TaskManagerApp: App {
    @StateObject private var taskManager = TaskManager()

    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environmentObject(taskManager)
        }
    }
}
