//
//  TaskTableViewCell.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-27.
//

import UIKit
import SnapKit

final class TaskTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "TaskTableViewCell"
    var currentItem: TodoItem!
    
    weak var delegate: PassDataBackDelegate?
    
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
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "24 June"
        label.textColor = ColorScheme.tertiaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deadlineStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: Symbols.calendarDeadlineSymbol)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(imageView.image?.size.width ?? 0)
        }
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(deadlineLabel)
        
        return stack
    }()
    
    private lazy var labelAndDeadlineStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var symbolAndTaskLabelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
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
        stack.addArrangedSubview(symbolAndTaskLabelStackView)
        
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
    
    override func prepareForReuse() {
        symbolAndTaskLabelStackView.arrangedSubviews.forEach { subview in
            symbolAndTaskLabelStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        labelAndDeadlineStackView.arrangedSubviews.forEach { subview in
            symbolAndTaskLabelStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        radioButtonView.image = Symbols.regularTaskButtonSymbol
        let attributedText = NSMutableAttributedString(string: taskLabel.text ?? "")
        taskLabel.attributedText = attributedText
        taskLabel.textColor = ColorScheme.primaryLabel
        super.prepareForReuse()
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
    
    // MARK: - Interaction andling
    @objc private func didTapRadioButton() {
        currentItem.isDone.toggle()
        markTaskAsDone(currentItem.isDone, isHighPriority: currentItem.priority == .important, hasDeadline: currentItem.deadline != nil)
        delegate?.changeItemCompleteness(itemID: currentItem.id)
    }
    
    
    // MARK: - Configuring the cell
    func configureCell(with item: TodoItem, at indexPath: IndexPath) {
        currentItem = item
        
        taskLabel.text = item.text
        if let deadline = item.deadline {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "dd MMMM"
            let dateString = dateFormatter.string(from: deadline)
            deadlineLabel.text = dateString
        }
        markTaskAsDone(item.isDone, isHighPriority: item.priority == .important, hasDeadline: item.deadline != nil)
    }
    
    func markTaskAsDone(_ isDone: Bool, isHighPriority: Bool, hasDeadline: Bool) {
        if isDone {
            symbolAndTaskLabelStackView.arrangedSubviews.forEach { subview in
                symbolAndTaskLabelStackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
            symbolAndTaskLabelStackView.addArrangedSubview(taskLabel)
            
            radioButtonView.image = Symbols.checkedTaskButtonSymbol
            
            let attributedText = NSMutableAttributedString(string: taskLabel.text ?? "")
            attributedText.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedText.length))
            
            taskLabel.attributedText = attributedText
            taskLabel.textColor = ColorScheme.disabledLabel
        } else {
            symbolAndTaskLabelStackView.arrangedSubviews.forEach { subview in
                symbolAndTaskLabelStackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
            
            if isHighPriority {
                let imageView = UIImageView(image: Symbols.doubleExclamationMarkSymbol)
                symbolAndTaskLabelStackView.addArrangedSubview(imageView)
                
                imageView.snp.makeConstraints { make in
                    make.width.equalTo(imageView.image?.size.width ?? 0)
                }
                radioButtonView.image = Symbols.highPriorityTaskButtonSymbol
            } else {
                radioButtonView.image = Symbols.regularTaskButtonSymbol
            }
            
            labelAndDeadlineStackView.addArrangedSubview(taskLabel)
            let attributedText = NSMutableAttributedString(string: taskLabel.text ?? "")
            taskLabel.attributedText = attributedText
            taskLabel.textColor = ColorScheme.primaryLabel
            
            if hasDeadline {
                labelAndDeadlineStackView.addArrangedSubview(deadlineStackView)
            }
            
            symbolAndTaskLabelStackView.addArrangedSubview(labelAndDeadlineStackView)
            
        }
    }
}
