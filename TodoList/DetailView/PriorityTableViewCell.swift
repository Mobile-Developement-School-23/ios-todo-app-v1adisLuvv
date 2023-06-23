//
//  PriorityTableViewCell.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-22.
//

import UIKit
import SnapKit

final class PriorityTableViewCell: UITableViewCell {
    
    static let identifier = "PriorityTableViewCell"
    
    weak var delegate: DidChangePriorityDelegate?
    
    // MARK: - UI Elements
    private lazy var priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "Priority"
        label.textColor = ColorScheme.primaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items: [Any] = [Symbols.arrowDownSymbol, "no", Symbols.doubleExclamationMarkSymbol]
        let segControl = UISegmentedControl(items: items)
        segControl.selectedSegmentIndex = 1
        segControl.addTarget(self, action: #selector(didChangePriority), for: .valueChanged)
        return segControl
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(priorityLabel)
        stack.addArrangedSubview(segmentedControl)
        
        contentView.addSubview(stack)
        return stack
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-12)
        }
        
    }
    
    @objc private func didChangePriority() {
        delegate?.didChangePriority(selectedIndex: segmentedControl.selectedSegmentIndex)
    }
}
