//
//  TodoItem+JSON.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-03.
//

import Foundation

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        
        guard let jsonDict = json as? [String: Any] else { return nil }
        
        // must exist
        guard let id = jsonDict[FieldName.id.rawValue] as? String, !id.isEmpty,
              let text = jsonDict[FieldName.text.rawValue] as? String, !text.isEmpty,
              let isDone = jsonDict[FieldName.isDone.rawValue] as? Bool
        else { return nil }
        
        // basic if not exists
        let priority = Priority(rawValue: jsonDict[FieldName.priority.rawValue] as? String ?? "") ?? Priority.basic
        
        // must exist
        guard let dateCreatedTimestamp = jsonDict[FieldName.dateCreated.rawValue] as? Double else { return nil }
        let dateCreated = Date(timeIntervalSince1970: dateCreatedTimestamp)
        
        var deadline: Date? // remains nil if not exists
        if let deadlineTimestamp = jsonDict[FieldName.deadline.rawValue] as? Double {
            deadline = Date(timeIntervalSince1970: deadlineTimestamp)
        }
        
        var dateModified: Date? // remains nil if not exists
        if let dateModifiedTimestamp = jsonDict[FieldName.dateModified.rawValue] as? Double {
            dateModified = Date(timeIntervalSince1970: dateModifiedTimestamp)
        }
        
        let todoItem = TodoItem(id: id, text: text, priority: priority, deadline: deadline, isDone: isDone, dateCreated: dateCreated, dateModified: dateModified)
        
        return todoItem
    }
    
    var json: Any {
        
        var jsonDict: [String: Any] = [FieldName.id.rawValue: id,
                                       FieldName.text.rawValue: text,
                                       FieldName.isDone.rawValue: isDone]
        
        if priority != .basic {
            jsonDict[FieldName.priority.rawValue] = priority.rawValue
        }
        
        if let deadline = deadline {
            jsonDict[FieldName.deadline.rawValue] = deadline.timeIntervalSince1970 // TimeInterval stored in dict is Double
        }
        
        jsonDict[FieldName.dateCreated.rawValue] = dateCreated.timeIntervalSince1970
        
        if let dateModified = dateModified {
            jsonDict[FieldName.dateModified.rawValue] = dateModified.timeIntervalSince1970
        }
        
        return jsonDict
    }
}
