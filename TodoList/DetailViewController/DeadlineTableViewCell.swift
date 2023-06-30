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
    
    weak var delegate: DidToggleDeadlineSwitchDelegate?
    
    // MARK: - UI Elements
    private lazy var doUntillabel: UILabel = {
        let label = UILabel()
        label.text = "Do until"
        label.textColor = ColorScheme.primaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorScheme.blue
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(doUntillabel)
        
        addSubview(stack)
        return stack
    }()
    
    private lazy var deadlineSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = ColorScheme.green
        sw.addTarget(self, action: #selector(didTapDeadlineSwitch), for: .valueChanged)
        return sw
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(labelsStackView)
        stack.addArrangedSubview(deadlineSwitch)
        
        contentView.addSubview(stack)
        return stack
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
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-12)
        }
        
    }
    
    @objc private func didTapDeadlineSwitch() {
        delegate?.didToggleDeadlineSwitch(isOn: deadlineSwitch.isOn)
    }
    
    func configureDeadline(withDate date: Date?) {
        if let date = date {
            deadlineSwitch.setOn(true, animated: false)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let dateString = dateFormatter.string(from: date)
            deadlineLabel.text = dateString
            labelsStackView.addArrangedSubview(deadlineLabel)
            layoutIfNeeded()
        } else {
            deadlineSwitch.setOn(false, animated: false)
            deadlineLabel.removeFromSuperview()
            layoutIfNeeded()
        }
    }
}
