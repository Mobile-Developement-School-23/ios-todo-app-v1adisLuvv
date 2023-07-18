//
//  NetworkingSevice.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-06.
//

import Foundation

protocol NetworkingService {
    static func loadList() async throws -> [ServerElement]
    static func updateList(withList list: [ServerElement]) async throws -> [ServerElement]
    static func loadItem(itemID id: String) async throws -> ServerElement
    static func uploadItem(item: ServerElement) async throws -> ServerElement
    static func updateItem(itemID id: String, withItem item: ServerElement) async throws -> ServerElement
    static func deleteItem(itemID id: String) async throws -> ServerElement
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
