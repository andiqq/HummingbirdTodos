import Foundation

actor TodoMemoryRepository: TodoRepository {
    var todos: [UUID: Todo]
    
    init() {
        self.todos = [:]
    }
    
    func create(title: String, order: Int?, urlPrefix: String) async throws -> Todo {
        let id = UUID()
        let url = urlPrefix + id.uuidString
        let todo = Todo(id: id, title: title, url: url, completed: false)
        self.todos[id] = todo
        return todo
    }
    
    func get(id: UUID) async throws -> Todo? {
        self.todos[id]
    }
    
    func list() async throws -> [Todo] {
        self.todos.values.map { $0 }
    }
    
    func update(id: UUID, title: String?, order: Int?, completed: Bool?) async throws -> Todo? {
        guard var todo = self.todos[id]
        else { return nil }
        
        if let title {
            todo.title = title
        }
        if let order {
            todo.order = order
        }
        if let completed {
            todo.completed = completed
        }
        self.todos[id] = todo
        return todo
    }
    
    func delete(id: UUID) async throws -> Bool {
        guard self.todos[id] != nil
        else { return false }
        
        self.todos[id] = nil
        return true
    }
    
    func deleteAll() async throws {
        self.todos = [:]
    }
}
