//
//  DidChangePriorityDelegate.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-23.
//

import Foundation

protocol DidChangePriorityDelegate: AnyObject {
    func didChangePriority(selectedIndex: Int)
}
