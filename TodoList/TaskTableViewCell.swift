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
    private lazy var radioButtonView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Symbols.regularTaskButtonSymbol
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapRadioButton))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Task"
        label.textColor = ColorScheme.primaryLabel
        label.textAlignment = .left
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var radioButtonAndLabelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(radioButtonView)
        stack.addArrangedSubview(taskLabel)
        
        contentView.addSubview(stack)
        return stack
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = ColorScheme.secondaryBackground
        let disclosureImageView = UIImageView(image: Symbols.tableViewDisclosureSymbol)
        accessoryView = disclosureImageView
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        
        radioButtonView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
        
        radioButtonAndLabelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-32)
            make.top.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    @objc private func didTapRadioButton() {
        if radioButtonView.image != Symbols.checkedTaskButtonSymbol {
            radioButtonView.image = Symbols.checkedTaskButtonSymbol
        } else {
            radioButtonView.image = Symbols.regularTaskButtonSymbol
        }
    }
}
