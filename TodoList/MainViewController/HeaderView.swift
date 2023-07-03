//
//  HeaderView.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-03.
//

import UIKit
import SnapKit

final class HeaderView: UIView {
    
    var showCompletedItems = false {
        didSet {
            showHideButton.setTitle(showCompletedItems ? "Hide" : "Show", for: .normal)
        }
    }
    
    private var tableViewWidth: CGFloat
    private var headerHeight: CGFloat
    
    private lazy var completedLabel: UILabel = {
        let label = UILabel()
        label.text = "Completed - 0"
        label.textColor = ColorScheme.tertiaryLabel
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showHideButton: UIButton = {
        let button = UIButton()
        button.setTitle(showCompletedItems ? "Hide" : "Show", for: .normal)
        button.setTitleColor(ColorScheme.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(frame: CGRect, tableViewWidth: CGFloat, headerHeight: CGFloat) {
        self.tableViewWidth = tableViewWidth
        self.headerHeight = headerHeight
        super.init(frame: frame)
    }
    
    convenience init(tableViewWidth: CGFloat, headerHeight: CGFloat) {
        let frame = CGRect(x: 0, y: 0, width: tableViewWidth, height: headerHeight)
        self.init(frame: frame, tableViewWidth: tableViewWidth, headerHeight: headerHeight)
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader() {
        
        backgroundColor = ColorScheme.mainPrimaryBackground
        
        addSubview(completedLabel)
        addSubview(showHideButton)
        setupConstraints()
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
    
    func updateCompletedLabel(items: [TodoItem]) {
        let completedItems = items.reduce(0) { count, item in
            return count + (item.isDone ? 1 : 0)
        }
        completedLabel.text = "Completed - \(completedItems)"
    }
    
    func addTargetForShowHideButton(_ target: Any?, action: Selector) {
        showHideButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
