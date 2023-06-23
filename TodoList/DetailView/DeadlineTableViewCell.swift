//
//  DeadlineTableViewCell.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-22.
//

import UIKit
import SnapKit

final class DeadlineTableViewCell: UITableViewCell {

    static let identifier = "DeadlineTableViewCell"
    
    // MARK: - UI Elements
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Do until"
        label.textColor = ColorScheme.primaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deadlineSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.onTintColor = ColorScheme.green
        return sw
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(deadlineSwitch)
        
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
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-12)
        }
        
    }
    
}
