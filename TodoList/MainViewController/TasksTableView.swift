//
//  TasksTableView.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-03.
//

import UIKit

final class TasksTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupTableView() {
        separatorInset = UIEdgeInsets(top: 0, left: 16 + 28 + 12, bottom: 0, right: 0)
        register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        backgroundColor = ColorScheme.mainPrimaryBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
