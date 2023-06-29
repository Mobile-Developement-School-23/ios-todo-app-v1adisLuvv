//
//  TaskTableViewCellCompletedDelegate.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-29.
//

import Foundation

protocol TaskTableViewCellCompletedDelegate: AnyObject {
    func updateCompletedLabel(increase: Bool)
}
