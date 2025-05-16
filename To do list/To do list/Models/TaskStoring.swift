import Foundation

protocol TaskStoring {
    func save(tasks: [Task])
    func load() -> [Task]
}
