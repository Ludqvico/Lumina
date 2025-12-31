//
//  TaskListView.swift
//  TaskManager
//
//  Created by Lumina on 2025
//

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingAddTask = false
    @State private var searchText = ""
    @State private var showCompletedTasks = true
    @State private var selectedPriority: Task.Priority?
    @State private var showingFilterSheet = false

    var filteredTasks: [Task] {
        taskManager.filterTasks(
            showCompleted: showCompletedTasks,
            priority: selectedPriority,
            searchText: searchText
        )
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Statistics Header
                statsHeader

                // Task List
                if filteredTasks.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(filteredTasks) { task in
                            NavigationLink(destination: TaskDetailView(task: task)) {
                                TaskRowView(task: task)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    taskManager.deleteTask(task)
                                } label: {
                                    Label("Elimina", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    taskManager.toggleTaskCompletion(task)
                                } label: {
                                    Label(
                                        task.isCompleted ? "Da fare" : "Completato",
                                        systemImage: task.isCompleted ? "arrow.uturn.backward" : "checkmark"
                                    )
                                }
                                .tint(task.isCompleted ? .orange : .green)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $searchText, prompt: "Cerca task...")
                }
            }
            .navigationTitle("I Miei Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
            .sheet(isPresented: $showingFilterSheet) {
                FilterView(
                    showCompleted: $showCompletedTasks,
                    selectedPriority: $selectedPriority
                )
            }
        }
    }

    private var statsHeader: some View {
        HStack(spacing: 20) {
            StatCard(
                title: "Da Fare",
                count: taskManager.pendingTasksCount,
                color: .blue
            )

            StatCard(
                title: "Completati",
                count: taskManager.completedTasksCount,
                color: .green
            )

            StatCard(
                title: "In Ritardo",
                count: taskManager.overdueTasks.count,
                color: .red
            )
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 70))
                .foregroundColor(.gray)

            Text("Nessun Task")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Tocca + per aggiungere un nuovo task")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Task Row View

struct TaskRowView: View {
    let task: Task

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(task.isCompleted ? .green : .gray)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)

                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 8) {
                    PriorityBadge(priority: task.priority)

                    if let dueDate = task.dueDate {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                            Text(dueDate, style: .date)
                        }
                        .font(.caption)
                        .foregroundColor(dueDate < Date() && !task.isCompleted ? .red : .secondary)
                    }
                }
                .padding(.top, 4)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Priority Badge

struct PriorityBadge: View {
    let priority: Task.Priority

    var body: some View {
        Text(priority.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(6)
    }

    private var color: Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let count: Int
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Filter View

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showCompleted: Bool
    @Binding var selectedPriority: Task.Priority?

    var body: some View {
        NavigationView {
            Form {
                Section("Visualizzazione") {
                    Toggle("Mostra task completati", isOn: $showCompleted)
                }

                Section("Priorità") {
                    Button("Tutte") {
                        selectedPriority = nil
                    }
                    .foregroundColor(selectedPriority == nil ? .blue : .primary)

                    ForEach(Task.Priority.allCases, id: \.self) { priority in
                        Button(priority.rawValue) {
                            selectedPriority = priority
                        }
                        .foregroundColor(selectedPriority == priority ? .blue : .primary)
                    }
                }
            }
            .navigationTitle("Filtri")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fatto") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
            .environmentObject(TaskManager())
    }
}
