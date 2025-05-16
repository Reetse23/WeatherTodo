import Foundation
import Realm
import RealmSwift

class RealmTaskStorage: TaskStoring {
    private var realm: Realm
    
    init() {
        do {
            realm = try Realm()
            print("Realm file location: \(realm.configuration.fileURL?.absoluteString ?? "unknown")")
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func save(tasks: [Task]) {
        do {
            try realm.write {
                realm.delete(realm.objects(Task.self))
                realm.add(tasks)
            }
        } catch {
            print("Failed to save tasks to Realm: \(error)")
        }
    }
    
    func load() -> [Task] {
        return Array(realm.objects(Task.self))
    }
    
    func addTask(_ task: Task) {
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print("Failed to add task: \(error)")
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        do {
            try realm.write {
                task.isCompleted.toggle()
            }
        } catch {
            print("Failed to toggle task completion: \(error)")
        }
    }
    
    func deleteTask(_ task: Task) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}
