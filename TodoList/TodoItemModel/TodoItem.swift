//
//  TodoItem.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-03.
//

import Foundation

struct TodoItem {
    let id: String
    var text: String
    var priority: Priority
    var deadline: Date?
    var isDone: Bool
    let dateCreated: Date
    var dateModified: Date?
    
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
extension TodoItem: Equatable, Identifiable {}

enum Priority: String {
    case low
    case basic
    case important
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
