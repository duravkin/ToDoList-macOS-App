import Foundation

struct ToDoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var creationDate: Date

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, creationDate : Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.creationDate = creationDate
    }
}
