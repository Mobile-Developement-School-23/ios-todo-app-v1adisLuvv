//
//  FIleCacheSQLite.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-13.
//

import Foundation
import SQLite

final class FileCacheSQLite: FileCacheProtocol {
    
    private var db: Connection?
    
    private let todoItems = Table("TodoItems")
    
    private let id = Expression<String>("id")
    private let text = Expression<String>("text")
    private let priority = Expression<String>("priority")
    private let deadline = Expression<Date?>("deadline")
    private let isDone = Expression<Bool>("isDone")
    private let dateCreated = Expression<Date>("dateCreated")
    private let dateModified = Expression<Date?>("dateModified")
    
    static let shared = FileCacheSQLite()
    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appending(path: "TodoList")
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path(), withIntermediateDirectories: true)
                let dpPath = dirPath.appending(path: "dp.sqlite3").path
                db = try Connection(dpPath)
                createTable()
            } catch {
                db = nil
                print(error)
            }
        } else {
            db = nil
        }
    }
    
    private func createTable() {
        guard let db = db else { return }
        
        do {
            try db.run(todoItems.create { t in
                t.column(id, primaryKey: true)
                t.column(text)
                t.column(priority)
                t.column(deadline)
                t.column(isDone)
                t.column(dateCreated)
                t.column(dateModified)
            })
        } catch {
            print(error)
        }
    }
    
    func load() throws -> [TodoItem] {
        guard let db = db else { return [] }
        
        var items: [TodoItem] = []
        for item in try db.prepare(todoItems) {
            items.append(TodoItem(id: item[id],
                                  text: item[text],
                                  priority: Priority(rawValue: item[priority]) ?? .basic,
                                  deadline: item[deadline],
                                  isDone: item[isDone],
                                  dateCreated: item[dateCreated],
                                  dateModified: item[dateModified]))
        }
        
        return items
    }
    
    func insert(_ item: TodoItem) throws {
        guard let db = db else { return }
        
        let insert = todoItems.insert(id <- item.id,
                                      text <- item.text, priority <- item.priority.rawValue,
                                      deadline <- item.deadline,
                                      isDone <- item.isDone,
                                      dateCreated <- item.dateCreated,
                                      dateModified <- item.dateModified)
        
        try db.run(insert)
    }
    
    func update(itemID: String, to item: TodoItem) throws {
        guard let db = db else { return }
        
        let itemToUpdate = todoItems.filter(id == itemID)
        let update = itemToUpdate.update(id <- item.id,
                                         text <- item.text, priority <- item.priority.rawValue,
                                         deadline <- item.deadline,
                                         isDone <- item.isDone,
                                         dateCreated <- item.dateCreated,
                                         dateModified <- item.dateModified)
        
        try db.run(update)
    }
    
    func delete(_ itemID: String) throws {
        guard let db = db else { return }
        
        let itemToDelete = todoItems.filter(id == itemID)
        try db.run(itemToDelete.delete())
    }
}
