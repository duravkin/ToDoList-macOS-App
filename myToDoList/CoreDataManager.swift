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
}
