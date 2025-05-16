import SwiftUI

struct TaskCreatorView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    
    var onAdd: (Task) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description (optional)", text: $description)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let task = Task(title: title, description: description)
                        onAdd(task)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
