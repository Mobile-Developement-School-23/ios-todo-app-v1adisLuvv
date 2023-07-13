//
//  FileCache.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-03.
//

import CoreData

final class FileCacheCoreData {
    
    static let shared = FileCacheCoreData()
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoItemCoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func load() -> [TodoItem] {
        let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
        
        do {
            let fetchedItems = try mainContext.fetch(fetchRequest)
            var items: [TodoItem] = []
            
            for fetchedItem in fetchedItems {
                let item = TodoItem(id: fetchedItem.id, text: fetchedItem.text, priority: Priority(rawValue: fetchedItem.priority)!, deadline: fetchedItem.deadline, isDone: fetchedItem.isDone, dateCreated: fetchedItem.dateCreated, dateModified: fetchedItem.dateModified)
                items.append(item)
            }
            
            return items
        } catch {
            print(error)
        }
        return []
    }
    
    func insert(_ item: TodoItem) {
        let context = mainContext
        let entity = TodoItemCoreData.entity()
        let newObject = TodoItemCoreData(entity: entity, insertInto: context)
        newObject.id = item.id
        newObject.text = item.text
        newObject.priority = item.priority.rawValue
        newObject.deadline = item.deadline
        newObject.isDone = item.isDone
        newObject.dateCreated = item.dateCreated
        newObject.dateModified = item.dateModified
        saveContext()
    }
    
    func update(itemID: String, to item: TodoItem) throws {
        let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id)
        
        if let object = try mainContext.fetch(fetchRequest).first {
            object.id = item.id
            object.text = item.text
            object.priority = item.priority.rawValue
            object.deadline = item.deadline
            object.isDone = item.isDone
            object.dateCreated = item.dateCreated
            object.dateModified = item.dateModified
            saveContext()
        }
        
    }
    
    func delete(_ itemID: String) throws {
        let fetchRequest: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", itemID)
        
        if let object = try mainContext.fetch(fetchRequest).first {
            mainContext.delete(object)
            saveContext()
        }
        
    }
}
