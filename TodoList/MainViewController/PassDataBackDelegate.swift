//
//  PassDataBackDelegate.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-30.
//

import Foundation

protocol PassDataBackDelegate: AnyObject {
    func updateExistingItem(_ item: TodoItem)
    func createNewItem(_ item: TodoItem)
    func changeItemCompleteness(indexPath: IndexPath)
    func removeExistingItem()
}
