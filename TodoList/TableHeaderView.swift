//
//  TableHeaderView.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-28.
//

import UIKit
import SnapKit

final class TableHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "TableHeaderView"
    
    private lazy var completedLabel: UILabel = {
        let label = UILabel()
        label.text = "Completed - 0"
        label.textColor = ColorScheme.tertiaryLabel
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var showHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show", for: .normal)
        button.setTitleColor(ColorScheme.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
//        button.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        completedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        showHideButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        
    }
}
