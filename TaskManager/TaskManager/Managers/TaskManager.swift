//
//  TaskManager.swift
//  TaskManager
//
//  Created by Lumina on 2025
//

import Foundation

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []

    private let tasksKey = "SavedTasks"

    init() {
        loadTasks()
    }

    // MARK: - CRUD Operations

    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
    }

    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }

    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }

    // MARK: - Filtering and Sorting

    func filterTasks(showCompleted: Bool, priority: Task.Priority? = nil, searchText: String = "") -> [Task] {
        var filtered = tasks

        if !showCompleted {
            filtered = filtered.filter { !$0.isCompleted }
        }

        if let priority = priority {
            filtered = filtered.filter { $0.priority == priority }
        }

        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }

        return filtered.sorted { task1, task2 in
            if task1.isCompleted != task2.isCompleted {
                return !task1.isCompleted
            }

            if task1.priority != task2.priority {
                return task1.priority.rawValue > task2.priority.rawValue
            }

            if let date1 = task1.dueDate, let date2 = task2.dueDate {
                return date1 < date2
            }

            return task1.createdDate > task2.createdDate
        }
    }

    // MARK: - Persistence

    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }

    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        } else {
            // Load sample tasks for first launch
            tasks = Task.sampleTasks
            saveTasks()
        }
    }

    // MARK: - Statistics

    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }

    var pendingTasksCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }

    var overdueTasks: [Task] {
        tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return dueDate < Date() && !task.isCompleted
        }
    }
}
