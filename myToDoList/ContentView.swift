import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ToDoListViewModel()
    @State private var newTaskTitle: String = ""
    @State private var editingItem: ToDoItem? = nil // Храним редактируемую задачу
    @State private var editedTaskTitle: String = "" // Храним новое название задачи
    
    func addNewTask(){
        guard !newTaskTitle.isEmpty else { return }
        viewModel.addItem(title: newTaskTitle)
        newTaskTitle = ""
    }
    
    func deleteTask(item: ToDoItem){
        if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
            viewModel.deleteItem(at: IndexSet([index]))
        }
    }
    
    func saveEditTask(){
        guard let item = editingItem else { return }
        viewModel.updateItem(for: item, newTitle: editedTaskTitle)
        self.editingItem = nil
        self.editedTaskTitle = ""
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
                        .onSubmit {
                            addNewTask()
                        }
                    
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
                            Button(action: {
                                editingItem = item
                                editedTaskTitle = item.title
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
                        .contextMenu {
                            Button(action: {
                                // Инициализируем редактируемую задачу и открываем текстовое поле
                                editingItem = item
                                editedTaskTitle = item.title
                            }) {
                                Text("Edit")
                                Image(systemName: "pencil")
                            }
                            Button(action: {
                                deleteTask(item: item)
                            }) {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding()
            }

            // Если редактируемая задача есть, показываем текстовое поле для редактирования
            if let editingItem = editingItem {
                VStack {
                    Text("Editing: \(editingItem.title)")
                        .font(.headline)
                        .padding()

                    TextField("Edit task title", text: $editedTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onSubmit {
                            saveEditTask()
                        }

                    HStack {
                        Button("Save") {
                            saveEditTask()
                        }
                        .padding()
                        Button("Cancel") {
                            // Отменяем редактирование
                            self.editingItem = nil
                            self.editedTaskTitle = ""
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
    }
}
