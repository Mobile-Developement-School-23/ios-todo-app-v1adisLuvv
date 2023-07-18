//
//  FileCacheProtocol.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-13.
//

import Foundation

protocol FileCacheProtocol {
    func load() throws -> [TodoItem]
    func insert(_ item: TodoItem) throws
    func update(itemID: String, to item: TodoItem) throws
    func delete(_ itemID: String) throws
}
