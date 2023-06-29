//
//  MainView.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-27.
//

import UIKit
import SnapKit

final class MainView: UIView {
    
    private var items: [TodoItem] = []
    private var completedItemsCounter = 0
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16 + 28 + 12, bottom: 0, right: 0)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ColorScheme.mainPrimaryBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ColorScheme.blue
        button.layer.cornerRadius = 44 / 2
        button.layer.masksToBounds = false // allow the shadow to be visible outside the bounds
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 44 / 8
        let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
        button.setImage(plusImage, for: .normal)
        button.tintColor = ColorScheme.white
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        return button
    }()
    
    
    // MARK: - Header Elements
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
        button.setTitle("Show", for: .normal)
        button.setTitleColor(ColorScheme.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
//        button.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - Footer Elements
    private lazy var newLabel: UILabel = {
        let label = UILabel()
        label.text = "New"
        label.textColor = ColorScheme.tertiaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorScheme.secondaryBackground
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.cornerRadius = 16
        // target
        view.addSubview(newLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var clearView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorScheme.mainPrimaryBackground
        return view
    }()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorScheme.mainPrimaryBackground
        
        loadTodoItems()
        createHeader()
        createFooter()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = ColorScheme.mainPrimaryBackground
        
        headerView.addSubview(completedLabel)
        headerView.addSubview(showHideButton)
        
        completedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        showHideButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        tableView.tableHeaderView = headerView
    }
    
    private func createFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 56 + 86))
        footerView.backgroundColor = ColorScheme.mainPrimaryBackground
        
        footerView.addSubview(whiteView)
        footerView.addSubview(clearView)
        
        newLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16 + 28 + 12)
            make.centerY.equalToSuperview()
        }
        
        whiteView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(56)
        }
        
        clearView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom)
            make.height.equalTo(86)
        }
        
        
        tableView.tableFooterView = footerView
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-54)
            make.width.height.equalTo(44)
        }
    }
    
    private func loadTodoItems() {
        let fileCache = FileCache.shared
        let item1 = TodoItem(text: "buy cheese", priority: .regular, isDone: false)
        let item2 = TodoItem(text: "buy milk", priority: .high, isDone: false)
        let item3 = TodoItem(text: "buy bread", priority: .low, isDone: true)
        fileCache.addTask(item1)
        fileCache.addTask(item2)
        fileCache.addTask(item3)
        items = fileCache.todoItems
    }
    
}

extension MainView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let maskPath = UIBezierPath(roundedRect: cell.bounds,
                                        byRoundingCorners: [.topLeft, .topRight],
                                        cornerRadii: CGSize(width: 16, height: 16))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            cell.layer.mask = shape
        } else {
            let maskPath = UIBezierPath(roundedRect: cell.bounds,
                                        byRoundingCorners: [.allCorners],
                                        cornerRadii: CGSize(width: 0, height: 0))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            cell.layer.mask = shape
        }
    }
}

extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        cell.completedDelegate = self
        
        let item = items[indexPath.row]
        cell.configureCell(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: "Mark as Done") { [weak self] _, _, completionHandler in
            if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                guard let self = self else { return }
                var item = self.items[indexPath.row]
                item.isDone.toggle()
                cell.markTaskAsDone(item.isDone, isHighPriority: item.priority == .high)
                completedItemsCounter += item.isDone ? 1 : -1
            }
            completionHandler(true)
        }
        
        doneAction.backgroundColor = ColorScheme.green
        doneAction.image = Symbols.checkedTaskLeadingSwipeSymbol

        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let infoAction = UIContextualAction(style: .normal, title: "Info") { _, _, completionHandler in
            print("Go to the detail screen")
            completionHandler(true)
        }
        
        infoAction.backgroundColor = ColorScheme.lightGray
        infoAction.image = Symbols.infoTrailingSwipeSymbol
        
        let deleteAction = UIContextualAction(style: .normal, title: "Info") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            if indexPath.row == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                }
            }
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = ColorScheme.red
        deleteAction.image = Symbols.deleteTrailingSwipeSymbol
        
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
}

extension MainView: TaskTableViewCellCompletedDelegate {
    func updateCompletedLabel(increase: Bool) {
        if increase {
            completedItemsCounter += 1
        } else {
            completedItemsCounter -= 1
        }
        completedLabel.text = "Completed - \(completedItemsCounter)"
    }
}
