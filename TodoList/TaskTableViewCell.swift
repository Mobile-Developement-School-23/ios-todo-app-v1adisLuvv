//
//  TaskTableViewCell.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-27.
//

import UIKit
import SnapKit

final class TaskTableViewCell: UITableViewCell {

    static let identifier = "TaskTableViewCell"
    
    // MARK: - UI Elements
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Task"
        label.textColor = ColorScheme.primaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = ColorScheme.secondaryBackground
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        
        taskLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
    }
}
