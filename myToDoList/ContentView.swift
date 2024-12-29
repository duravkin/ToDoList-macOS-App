import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ToDoListViewModel()
    @State private var newTaskTitle: String = ""
    @State private var newTaskPriorityID: UUID? = nil // Выбранный приоритет для новой задачи
    @State private var editingItem: ToDoItem? = nil // Храним редактируемую задачу
    @State private var editedTaskTitle: String = "" // Храним новое название задачи
    @State private var editedTaskPriorityID: UUID? = nil // Храним новый приоритет задачи
    
    func addNewTask() {
        guard !newTaskTitle.isEmpty, let priorityID = newTaskPriorityID else { return }
        viewModel.addItem(title: newTaskTitle, priorityID: priorityID)
        newTaskTitle = ""
        newTaskPriorityID = nil
    }
    
    func deleteTask(item: ToDoItem) {
        if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
            viewModel.deleteItem(at: IndexSet([index]))
        }
    }
    
    func saveEditTask() {
        guard let item = editingItem, let priorityID = editedTaskPriorityID else { return }
        viewModel.updateItem(for: item, newTitle: editedTaskTitle)
        viewModel.updateItemPriority(for: item, priorityID: priorityID)
        self.editingItem = nil
        self.editedTaskTitle = ""
        self.editedTaskPriorityID = nil
    }
    
    var body: some View {
        VStack {
            if editingItem == nil {
                Text("ToDo List")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    TextField("Enter new task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    Picker("Priority:", selection: $newTaskPriorityID) {
                        Text("Select").tag(UUID?.none)
                        ForEach(viewModel.priorities) { priority in
                            Text(priority.priority).tag(priority.id as UUID?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 130)
                    
                    Button(action: {
                        addNewTask()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.items) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    viewModel.toggleCompletion(for: item)
                                }
                            Text(item.title)
                                .strikethrough(item.isCompleted, color: .gray)
                            Spacer()
//                            Text(item.priority ?? "No priority")
                            Button(action: {
                                editingItem = item
                                editedTaskTitle = item.title
                                editedTaskPriorityID = viewModel.priorities.first(where: { $0.id == item.id })?.id
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            Button(action: {
                                deleteTask(item: item)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding()
            }
            
            // Если редактируемая задача есть, показываем текстовое поле и выбор приоритета для редактирования
            if let editingItem = editingItem {
                VStack {
                    Text("Editing: \(editingItem.title)")
                        .font(.headline)
                        .padding()
                    
                    TextField("Edit task title", text: $editedTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Picker("Edit Priority", selection: $editedTaskPriorityID) {
                        Text("Select Priority").tag(UUID?.none)
                        ForEach(viewModel.priorities) { priority in
                            Text(priority.priority).tag(priority.id as UUID?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    HStack {
                        Button("Save") {
                            saveEditTask()
                        }
                        .padding()
                        Button("Cancel") {
                            self.editingItem = nil
                            self.editedTaskTitle = ""
                            self.editedTaskPriorityID = nil
                        }
                        .padding()
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchPriorities()
        }
    }
}
//#Preview {
//    ContentView()
//}
