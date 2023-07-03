//
//  PassDataBackDelegate.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-30.
//

import Foundation

protocol PassDataBackDelegate: AnyObject {
    func updateExistingItem(withID itemID: String, changeTo item: TodoItem)
    func createNewItem(_ item: TodoItem)
    func changeItemCompleteness(itemID: String)
    func removeExistingItem(itemID: String)
}
