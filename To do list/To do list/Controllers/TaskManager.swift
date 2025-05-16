import Foundation

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var searchText: String = ""
    
    private let storage: RealmTaskStorage
    
    var filteredTasks: [Task] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var todoTasks: [Task] {
        filteredTasks.filter { !$0.isCompleted }
    }
    
    var completedTasks: [Task] {
        filteredTasks.filter { $0.isCompleted }
    }
    
    init(storage: RealmTaskStorage = RealmTaskStorage()) {
        self.storage = storage
        loadTasks()
    }
    
    func loadTasks() {
        tasks = storage.load()
    }
    
    func addTask(_ task: Task) {
        storage.addTask(task)
        loadTasks()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        storage.toggleTaskCompletion(task)
        loadTasks()
    }
    
    func deleteTask(_ task: Task) {
        storage.deleteTask(task)
        loadTasks()
    }
}
