//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by Lumina on 2025
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager

    let task: Task

    @State private var isEditing = false
    @State private var editedTitle = ""
    @State private var editedDescription = ""
    @State private var editedPriority: Task.Priority = .medium
    @State private var editedHasDueDate = false
    @State private var editedDueDate = Date()
    @State private var showingDeleteAlert = false

    var isFormValid: Bool {
        !editedTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        Form {
            if isEditing {
                editingSection
            } else {
                viewingSection
            }
        }
        .navigationTitle(isEditing ? "Modifica Task" : "Dettagli")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Salva") {
                        saveChanges()
                    }
                    .disabled(!isFormValid)
                } else {
                    Button("Modifica") {
                        startEditing()
                    }
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                if isEditing {
                    Button("Annulla") {
                        isEditing = false
                    }
                }
            }
        }
        .alert("Elimina Task", isPresented: $showingDeleteAlert) {
            Button("Elimina", role: .destructive) {
                deleteTask()
            }
            Button("Annulla", role: .cancel) {}
        } message: {
            Text("Sei sicuro di voler eliminare questo task?")
        }
    }

    // MARK: - Viewing Section

    private var viewingSection: some View {
        Group {
            Section("Informazioni") {
                HStack {
                    Text("Titolo")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(task.title)
                        .multilineTextAlignment(.trailing)
                }

                if !task.description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descrizione")
                            .foregroundColor(.secondary)
                        Text(task.description)
                    }
                }
            }

            Section("Stato") {
                HStack {
                    Text("Completato")
                        .foregroundColor(.secondary)
                    Spacer()
                    Button {
                        taskManager.toggleTaskCompletion(task)
                    } label: {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundColor(task.isCompleted ? .green : .gray)
                    }
                }

                HStack {
                    Text("Priorità")
                        .foregroundColor(.secondary)
                    Spacer()
                    PriorityBadge(priority: task.priority)
                }
            }

            Section("Date") {
                HStack {
                    Text("Creato")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(task.createdDate, style: .date)
                    Text(task.createdDate, style: .time)
                }

                if let dueDate = task.dueDate {
                    HStack {
                        Text("Scadenza")
                            .foregroundColor(.secondary)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(dueDate, style: .date)
                            Text(dueDate, style: .time)
                        }
                        .foregroundColor(dueDate < Date() && !task.isCompleted ? .red : .primary)
                    }

                    if dueDate < Date() && !task.isCompleted {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Task in ritardo")
                                .foregroundColor(.red)
                        }
                    }
                }
            }

            Section {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Elimina Task")
                        Spacer()
                    }
                }
            }
        }
    }

    // MARK: - Editing Section

    private var editingSection: some View {
        Group {
            Section("Informazioni") {
                TextField("Titolo", text: $editedTitle)

                TextField("Descrizione (opzionale)", text: $editedDescription, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("Priorità") {
                Picker("Priorità", selection: $editedPriority) {
                    ForEach(Task.Priority.allCases, id: \.self) { priority in
                        HStack {
                            Circle()
                                .fill(priorityColor(priority))
                                .frame(width: 12, height: 12)
                            Text(priority.rawValue)
                        }
                        .tag(priority)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Scadenza") {
                Toggle("Imposta scadenza", isOn: $editedHasDueDate)

                if editedHasDueDate {
                    DatePicker(
                        "Data di scadenza",
                        selection: $editedDueDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
        }
    }

    // MARK: - Actions

    private func startEditing() {
        editedTitle = task.title
        editedDescription = task.description
        editedPriority = task.priority
        editedHasDueDate = task.dueDate != nil
        editedDueDate = task.dueDate ?? Date()
        isEditing = true
    }

    private func saveChanges() {
        var updatedTask = task
        updatedTask.title = editedTitle.trimmingCharacters(in: .whitespaces)
        updatedTask.description = editedDescription.trimmingCharacters(in: .whitespaces)
        updatedTask.priority = editedPriority
        updatedTask.dueDate = editedHasDueDate ? editedDueDate : nil

        taskManager.updateTask(updatedTask)
        isEditing = false
    }

    private func deleteTask() {
        taskManager.deleteTask(task)
        dismiss()
    }

    private func priorityColor(_ priority: Task.Priority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

// MARK: - Preview

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskDetailView(task: Task.sampleTasks[0])
                .environmentObject(TaskManager())
        }
    }
}
