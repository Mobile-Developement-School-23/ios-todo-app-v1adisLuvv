//
//  FileCache.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-13.
//

import Foundation

protocol FileCache {
    func load()
    func insert()
    func update()
    func delete()
}
