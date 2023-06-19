//
//  TodoItem.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-17.
//

import Foundation

struct TodoItem {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isDone: Bool
    let dateCreated: Date
    let dateModified: Date?
    
    init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date? = nil, isDone: Bool = false, dateCreated: Date = Date(), dateModified: Date? = nil) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}

// we need this conformance to be able to check the equality of two TodoItems
extension TodoItem: Equatable {}

enum Priority: String {
    case low
    case regular
    case high
}

// enum representing the field names for JSON
enum FieldName: String {
    case id
    case text
    case priority
    case deadline
    case isDone
    case dateCreated
    case dateModified
}
