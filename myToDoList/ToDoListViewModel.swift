import CoreData

class ToDoListViewModel: ObservableObject {
    private let context = CoreDataManager.shared.container.viewContext

    @Published var items: [ToDoItem] = []

    init() {
        fetchItems()
    }

    func fetchItems() {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
            let completionSortDescriptor = NSSortDescriptor(key: "isCompleted", ascending: true)
            let dateSortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
            request.sortDescriptors = [completionSortDescriptor, dateSortDescriptor]
        
        do {
            let entities = try context.fetch(request)
            items = entities.map { ToDoItem(id: $0.id!, title: $0.title!, isCompleted: $0.isCompleted, creationDate: $0.creationDate ?? Date()) }
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    func addItem(title: String) {
        let entity = ToDoEntity(context: context)
        entity.id = UUID()
        entity.title = title
        entity.isCompleted = false
        entity.creationDate = Date()
        saveContext()
    }

    func toggleCompletion(for item: ToDoItem) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        do {
            if let entity = try context.fetch(request).first {
                entity.isCompleted.toggle()
                saveContext()
            }
        } catch {
            print("Failed to toggle completion: \(error)")
        }
    }

    func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = items[index]
            let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
            do {
                if let entity = try context.fetch(request).first {
                    context.delete(entity)
                    saveContext()
                }
            } catch {
                print("Failed to delete item: \(error)")
            }
        }
    }
    
    func updateItem(for item: ToDoItem, newTitle: String) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        do {
            if let entity = try context.fetch(request).first {
                entity.title = newTitle
                saveContext()
            }
        } catch {
            print("Failed to update title: \(error)")
        }
    }

    
    private func saveContext() {
        CoreDataManager.shared.saveContext()
        fetchItems()
    }
}
