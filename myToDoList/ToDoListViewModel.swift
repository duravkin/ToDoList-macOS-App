import CoreData

class ToDoListViewModel: ObservableObject {
    private let context = CoreDataManager.shared.container.viewContext

    @Published var items: [ToDoItem] = [] // Список задач
    @Published var priorities: [PriorityItem] = [] // Список приоритетов для выбора

    init() {
        fetchItems()
        fetchPriorities()
    }

    // Загрузка задач с сортировкой по приоритету и состоянию
    func fetchItems() {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
        let prioritySortDescriptor = NSSortDescriptor(key: "priority.priority", ascending: true)
        let completionSortDescriptor = NSSortDescriptor(key: "isCompleted", ascending: true)
        let dateSortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        request.sortDescriptors = [prioritySortDescriptor, completionSortDescriptor, dateSortDescriptor]
        
        do {
            let entities = try context.fetch(request)
            items = entities.map { entity in
                ToDoItem(
                    id: entity.id!,
                    title: entity.title!,
                    isCompleted: entity.isCompleted,
                    creationDate: entity.creationDate ?? Date()
                )
            }
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    // Загрузка списка приоритетов
    func fetchPriorities() {
        let request: NSFetchRequest<PriorityEntity> = PriorityEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let entities = try context.fetch(request)
            priorities = entities.map { entity in
                PriorityItem(
                    id: entity.id!,
                    priority: entity.priority!,
                    tasks: []
                )
            }
        } catch {
            print("Failed to fetch priorities: \(error)")
        }
    }

    // Добавление новой задачи с приоритетом
    func addItem(title: String, priorityID: UUID) {
        let entity = ToDoEntity(context: context)
        entity.id = UUID()
        entity.title = title
        entity.isCompleted = false
        entity.creationDate = Date()

        if let priority = fetchPriority(by: priorityID) {
            entity.priority = priority
        }
        
        saveContext()
    }

    // Обновление приоритета задачи
    func updateItemPriority(for item: ToDoItem, priorityID: UUID) {
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        do {
            if let entity = try context.fetch(request).first, let priority = fetchPriority(by: priorityID) {
                entity.priority = priority
                saveContext()
            }
        } catch {
            print("Failed to update item priority: \(error)")
        }
    }

    // Утилита: получить PriorityEntity по UUID
    private func fetchPriority(by id: UUID) -> PriorityEntity? {
        let request: NSFetchRequest<PriorityEntity> = PriorityEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch priority: \(error)")
            return nil
        }
    }

    // Остальные функции остались без изменений
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
