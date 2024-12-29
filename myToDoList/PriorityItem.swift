import Foundation

struct PriorityItem: Identifiable, Codable {
    let id: UUID
    var priority: String
    var tasks: [ToDoItem] // Список связанных задач

    // Инициализатор
    init(id: UUID = UUID(), priority: String, tasks: [ToDoItem] = []) {
        self.id = id
        self.priority = priority
        self.tasks = tasks
    }
}
