//
//  TodoItemConverter.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-06.
//

import UIKit

final class TodoItemConverter {
    
    static func convertTodoItemToServerElement(_ item: TodoItem) -> ServerElement {
        let id = item.id
        let text = item.text
        let priority = item.priority.rawValue
        var deadline: Int?
        if let deadlineDouble = item.deadline?.timeIntervalSince1970 {
            deadline = Int(deadlineDouble)
        }
        let isDone = item.isDone
        let color = "#FFFFFF"
        let dateCreated = Int(item.dateCreated.timeIntervalSince1970)
        var dateModified: Int?
        if let dateModifiedDouble = item.dateModified?.timeIntervalSince1970 {
            dateModified = Int(dateModifiedDouble)
        }
        let lastUpdatedBy = UIDevice.current.identifierForVendor?.uuidString ?? "iPhone"
        let element = ServerElement(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, color: color, dateCreated: dateCreated, dateModified: dateModified, lastUpdatedBy: lastUpdatedBy)
        return element
    }
    
    static func convertServerElementToTodoItem(_ element: ServerElement) -> TodoItem {
        let id = element.id
        let text = element.text
        let priority = Priority(rawValue: element.priority) ?? .basic
        var deadline: Date?
        if let deadlineInt = element.deadline {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineInt))
        }
        let isDone = element.isDone
        let dateCreated = Date(timeIntervalSince1970: TimeInterval(element.dateCreated))
        var dateModified: Date?
        if let dateModifiedInt = element.dateModified {
            dateModified = Date(timeIntervalSince1970: TimeInterval(dateModifiedInt))
        }
        let item = TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, dateCreated: dateCreated, dateModified: dateModified)
        return item
    }
    
}
