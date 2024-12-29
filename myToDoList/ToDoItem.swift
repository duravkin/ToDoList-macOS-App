import Foundation

struct ToDoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var creationDate: Date
    var priorityID: UUID

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        creationDate: Date = Date(),
        priorityID: UUID
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.priorityID = priorityID
    }
}
