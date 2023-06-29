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
    var isHighPriority = false
    var isDone = false
    
    weak var completedDelegate: TaskTableViewCellCompletedDelegate?
    
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
    
    private lazy var symbolAndLabelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        return stack
    }()
    
    private lazy var radioButtonAndLabelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(radioButtonView)
        stack.addArrangedSubview(symbolAndLabelStackView)
        
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
        
        taskLabel.setContentHuggingPriority(.required, for: .horizontal)
        
    }
    
    @objc private func didTapRadioButton() {
        isDone.toggle()
        markTaskAsDone(isDone, isHighPriority: isHighPriority)
        completedDelegate?.updateCompletedLabel(increase: isDone)
    }
    
    func configureCell(with item: TodoItem) {
        isHighPriority = item.priority == .high
        isDone = item.isDone
        
        if isHighPriority {
            let imageView = UIImageView(image: Symbols.doubleExclamationMarkSymbol)
            symbolAndLabelStackView.addArrangedSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.width.equalTo(imageView.image?.size.width ?? 0)
            }
        }
        
        
        symbolAndLabelStackView.addArrangedSubview(taskLabel)
        taskLabel.text = item.text
        
        markTaskAsDone(isDone, isHighPriority: isHighPriority)
        if isDone { completedDelegate?.updateCompletedLabel(increase: isDone) }
    }
    
    func markTaskAsDone(_ isDone: Bool, isHighPriority: Bool) {
        if isDone {
            if isHighPriority {
                symbolAndLabelStackView.arrangedSubviews.forEach { subview in
                    symbolAndLabelStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
                
                symbolAndLabelStackView.addArrangedSubview(taskLabel)
            }
            radioButtonView.image = Symbols.checkedTaskButtonSymbol
            let attributedText = NSMutableAttributedString(string: taskLabel.text ?? "")
            attributedText.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedText.length))
            taskLabel.attributedText = attributedText
            taskLabel.textColor = ColorScheme.disabledLabel
        } else {
            if isHighPriority {
                
                symbolAndLabelStackView.arrangedSubviews.forEach { subview in
                    symbolAndLabelStackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
                
                let imageView = UIImageView(image: Symbols.doubleExclamationMarkSymbol)
                symbolAndLabelStackView.addArrangedSubview(imageView)
                
                imageView.snp.makeConstraints { make in
                    make.width.equalTo(imageView.image?.size.width ?? 0)
                }
                
                symbolAndLabelStackView.addArrangedSubview(taskLabel)
                
                radioButtonView.image = Symbols.highPriorityTaskButtonSymbol
            } else {
                radioButtonView.image = Symbols.regularTaskButtonSymbol
            }
            let attributedText = NSMutableAttributedString(string: taskLabel.text ?? "")
            taskLabel.attributedText = attributedText
            taskLabel.textColor = ColorScheme.primaryLabel
        }
    }
}
