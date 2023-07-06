//
//  ServerList.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-06.
//

import Foundation

struct ServerRequestList: Codable {
    let status: String
    let list: [ServerElement]
}

struct ServerResponseList: Codable {
    let status: String
    let list: [ServerElement]
    let revision: Int
}

struct ServerRequestElement: Codable {
    let status: String
    let element: ServerElement
}

struct ServerResponseElement: Codable {
    let status: String
    let element: ServerElement
    let revision: Int
}

struct ServerElement: Codable {
    let id: String
    let text: String
    let priority: String
    let deadline: Int?
    let isDone: Bool
    let color: String?
    let dateCreated: Int
    let dateModified: Int?
    let lastUpdatedBy: String
    
    init(id: String, text: String, priority: String, deadline: Int? = nil, isDone: Bool = false, color: String? = nil, dateCreated: Int = Int(Date().timeIntervalSince1970), dateModified: Int? = nil, lastUpdatedBy: String) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.color = color
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.lastUpdatedBy = lastUpdatedBy
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case priority = "importance"
        case deadline
        case isDone = "done"
        case color
        case dateCreated = "created_at"
        case dateModified = "changed_at"
        case lastUpdatedBy = "last_updated_by"
    }
}
