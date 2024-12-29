import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ToDoModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to initialize: \(error.localizedDescription)")
            }
            self.createDefaultPriorities() // Создаём приоритеты по умолчанию при загрузке
        }
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data: \(error)")
            }
        }
    }

    private func createDefaultPriorities() {
        let context = container.viewContext

        let request: NSFetchRequest<PriorityEntity> = PriorityEntity.fetchRequest()

        do {
            let count = try context.count(for: request)
            if count == 0 {
                let highPriority = PriorityEntity(context: context)
                highPriority.id = UUID()
                highPriority.priority = "High"

                let mediumPriority = PriorityEntity(context: context)
                mediumPriority.id = UUID()
                mediumPriority.priority = "Medium"

                let lowPriority = PriorityEntity(context: context)
                lowPriority.id = UUID()
                lowPriority.priority = "Low"

                saveContext()
                print("Default priorities created.")
            }
        } catch {
            print("Failed to check or create default priorities: \(error)")
        }
    }
}
