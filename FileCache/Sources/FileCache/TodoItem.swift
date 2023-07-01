//
//  File.swift
//  
//
//  Created by Vlad Boguzh on 2023-07-01.
//

import Foundation

public struct TodoItem {
    public let id: String
    public var text: String
    public var priority: Priority
    public var deadline: Date?
    public var isDone: Bool
    public let dateCreated: Date
    public var dateModified: Date?
    
    public init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date? = nil, isDone: Bool = false, dateCreated: Date = Date(), dateModified: Date? = nil) {
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

public enum Priority: String {
    case low
    case regular
    case high
}

// enum representing the field names for JSON
public enum FieldName: String {
    case id
    case text
    case priority
    case deadline
    case isDone
    case dateCreated
    case dateModified
}
