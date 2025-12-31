//
//  AddTaskView.swift
//  TaskManager
//
//  Created by Lumina on 2025
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager

    @State private var title = ""
    @State private var description = ""
    @State private var priority: Task.Priority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date()

    @FocusState private var titleFieldFocused: Bool

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Informazioni") {
                    TextField("Titolo", text: $title)
                        .focused($titleFieldFocused)

                    TextField("Descrizione (opzionale)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Priorità") {
                    Picker("Priorità", selection: $priority) {
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
                    Toggle("Imposta scadenza", isOn: $hasDueDate)

                    if hasDueDate {
                        DatePicker(
                            "Data di scadenza",
                            selection: $dueDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }

                Section {
                    Button {
                        addTask()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Aggiungi Task")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Nuovo Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                titleFieldFocused = true
            }
        }
    }

    private func addTask() {
        let newTask = Task(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            priority: priority,
            dueDate: hasDueDate ? dueDate : nil
        )

        taskManager.addTask(newTask)
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

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
            .environmentObject(TaskManager())
    }
}
