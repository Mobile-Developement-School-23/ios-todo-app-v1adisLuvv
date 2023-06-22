//
//  FileCache.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-17.
//

import Foundation

final class FileCache {
    private(set) var todoItems: [TodoItem] = []
    
    func addTask(_ item: TodoItem) {
        // rewrite if the ID exists
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index] = item
        } else {
            todoItems.append(item)
        }
    }
    
    func removeTask(withID id: String) {
        // all ID's are unique so only item will be removed
        todoItems.removeAll { $0.id == id }
    }
    
    func saveJSONToFile(fileName: String) {
        let jsonItems = todoItems.map({ $0.json })
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonItems)
            try jsonData.write(to: fileURL(fileName: fileName))
        } catch {
            print("Error saving JSON to file:\n \(error)")
        }
    }
    
    func loadJSONFromFile(fileName: String) {
        do {
            let jsonData = try Data(contentsOf: fileURL(fileName: fileName))
            let jsonItems = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] ?? []
            let loadedItems = jsonItems.compactMap { TodoItem.parse(json: $0) } // excludes nil values
            todoItems = loadedItems
        } catch {
            print("Error loading JSON from file:\n \(error)")
        }
    }
    
    func saveCSVToFile(fileName: String) {
        let csvString = todoItems.map { $0.csv }.joined(separator: "\n")
        do {
            try csvString.write(to: fileURL(fileName: fileName), atomically: true, encoding: .utf8)
        } catch {
            print("Error saving CSV to file:\n \(error)")
        }
    }
    
    func loadCSVFromFile(fileName: String) {
        do {
            let csvString = try String(contentsOf: fileURL(fileName: fileName), encoding: .utf8)
            let csvRows = csvString.components(separatedBy: "\n")
            let csvItems = csvRows.compactMap { TodoItem.parse(csv: $0) } // excludes nil values
            todoItems = csvItems
        } catch {
            print("Error loading CSV from file:\n \(error)")
        }
    }
    
    // function returning the place where to save the data
    // in this app the data will be saved to Application Support
    private func fileURL(fileName: String) -> URL {
        guard let applicationSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        else { return URL(filePath: "") }
        
        let directoryURL = applicationSupportURL.appendingPathComponent("ToDoList")
        
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            print("Error creating directory:\n \(error)")
        }
        
        return directoryURL.appendingPathComponent(fileName)
    }
    
}
