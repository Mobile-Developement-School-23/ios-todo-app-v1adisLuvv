//
//  MainViewController.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-27.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    // MARK: - Variables
    private var items: [TodoItem] = []
    private var showCompletedItems = false {
        didSet {
            showHideButton.setTitle(showCompletedItems ? "Hide" : "Show", for: .normal)
        }
    }
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16 + 28 + 12, bottom: 0, right: 0)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ColorScheme.mainPrimaryBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
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
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
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
        button.setTitle(showCompletedItems ? "Hide" : "Show", for: .normal)
        button.setTitleColor(ColorScheme.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(didTapShowHideButton), for: .touchUpInside)
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAddButton))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        view.addSubview(newLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var clearView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorScheme.mainPrimaryBackground
        return view
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorScheme.mainPrimaryBackground
        
        loadTodoItems()
        createHeader()
        createFooter()
        setupConstraints()
        setupNavigationBar()
        updateCompletedLabel()
    }
    
    private func loadTodoItems() {
        let fileCache = FileCache.shared
        let item1 = TodoItem(text: "buy cheese", priority: .regular, deadline: Date(timeIntervalSinceNow: 200000), isDone: false)
        let item2 = TodoItem(text: "buy water", priority: .high, deadline: Date(timeIntervalSinceNow: 300000), isDone: false)
        let item3 = TodoItem(text: "buy milk", priority: .high, isDone: false)
        let item4 = TodoItem(text: "buy bread", priority: .low, isDone: true)
        let item5 = TodoItem(text: "buy apples", priority: .low, deadline: Date(timeIntervalSinceNow: 400000), isDone: true)
        fileCache.addTask(item1)
        fileCache.addTask(item2)
        fileCache.addTask(item3)
        fileCache.addTask(item4)
        fileCache.addTask(item5)
        
        items = fileCache.todoItems
    }
    
    
    // MARK: - Setup header and footer
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
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-54)
            make.width.height.equalTo(44)
        }
    }
    
    // MARK: - setupNavigationBar
    private func setupNavigationBar() {
        title = "My Tasks"
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        navigationBar.layoutMargins.left = 32
        
        let largeTitleAttributes = [
            NSAttributedString.Key.foregroundColor: ColorScheme.primaryLabel,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 38, weight: .bold)
        ]
        
        navigationBar.largeTitleTextAttributes = largeTitleAttributes
    }
    
    @objc private func didTapAddButton() {
        let detailVC = DetailViewController()
        detailVC.delegate = self
        present(detailVC, animated: true)
    }
    
    @objc private func didTapShowHideButton() {
        showCompletedItems.toggle()
        tableView.reloadData()
        view.layoutIfNeeded()
    }

}

// MARK: - UITableViewDelegate extension
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = DetailViewController(currentItem: selectedItem)
        detailVC.delegate = self
        present(detailVC, animated: true)
        
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifier = "\(indexPath.row)" as NSCopying
        let configuration = UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return UIMenu() }
            
            let checkAsCompletedAction = UIAction(title: "Complete", image: Symbols.checkedTaskButtonSymbol) { _ in
                if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                    let item = self.items[indexPath.row]
                    self.changeItemCompleteness(itemID: item.id)
                    cell.markTaskAsDone(item.isDone, isHighPriority: item.priority == .high, hasDeadline: item.deadline != nil)
                    self.updateCompletedLabel()
                }
            }
            
            let checkAsIncompletedAction = UIAction(title: "Incomplete", image: Symbols.regularTaskButtonSymbol) { _ in
                if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                    let item = self.items[indexPath.row]
                    self.changeItemCompleteness(itemID: item.id)
                    cell.markTaskAsDone(item.isDone, isHighPriority: item.priority == .high, hasDeadline: item.deadline != nil)
                    self.updateCompletedLabel()
                }
            }
            
            let makeImportantAction = UIAction(title: "Mark as important", image: Symbols.doubleExclamationMarkSymbol) { _ in
                let item = self.items[indexPath.row]
                self.changeItemPriority(withID: item.id, to: .high)
            }
            
            let makeRegularAction = UIAction(title: "Make as regular") { _ in
                let item = self.items[indexPath.row]
                self.changeItemPriority(withID: item.id, to: .regular)
            }
            
            let makeLowAction = UIAction(title: "Make as unimportant", image: Symbols.arrowDownSymbol) { _ in
                let item = self.items[indexPath.row]
                self.changeItemPriority(withID: item.id, to: .low)
            }
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                let item = self.items[indexPath.row]
                self.removeExistingItem(itemID: item.id)
            }
            
            var children: [UIMenuElement] = []
            
            if self.items[indexPath.row].isDone {
                children.append(checkAsIncompletedAction)
            } else {
                children.append(checkAsCompletedAction)
            }
            
            if self.items[indexPath.row].priority == .low {
                children.append(makeImportantAction)
                children.append(makeRegularAction)
            } else if self.items[indexPath.row].priority == .regular {
                children.append(makeImportantAction)
                children.append(makeLowAction)
            } else {
                children.append(makeRegularAction)
                children.append(makeLowAction)
            }
            
            children.append(deleteAction)
            
            return UIMenu(children: children)
        }
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        guard let identifier = configuration.identifier as? String,
              let index = Int(identifier),
              tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TaskTableViewCell != nil
        else { return }
        
        let selectedItem = items[index]
        
        let detailVC = DetailViewController(currentItem: selectedItem)
        detailVC.delegate = self
        
        animator.addCompletion { [weak self] in
            guard let self = self else { return }
            present(detailVC, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource extension
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showCompletedItems {
            return items.count
        } else {
            return items.filter { !$0.isDone }.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        
        var filteredItems: [TodoItem]
        if showCompletedItems {
            filteredItems = items
        } else {
            filteredItems = items.filter { !$0.isDone }
        }
        
        let item = filteredItems[indexPath.row]
        cell.configureCell(with: item, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: "Mark as Done") { [weak self] _, _, completionHandler in
            if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                guard let self = self else { return }
                let item = self.items[indexPath.row]
                self.changeItemCompleteness(itemID: item.id)
                cell.markTaskAsDone(item.isDone, isHighPriority: item.priority == .high, hasDeadline: item.deadline != nil)
                self.updateCompletedLabel()
            }
            completionHandler(true)
        }
        
        doneAction.backgroundColor = ColorScheme.green
        doneAction.image = Symbols.checkedTaskLeadingSwipeSymbol

        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let infoAction = UIContextualAction(style: .normal, title: "Info") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let selectedItem = self.items[indexPath.row]
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            let detailVC = DetailViewController(currentItem: selectedItem)
            detailVC.delegate = self
            self.present(detailVC, animated: true)
            completionHandler(true)
        }
        
        infoAction.backgroundColor = ColorScheme.lightGray
        infoAction.image = Symbols.infoTrailingSwipeSymbol
        
        let deleteAction = UIContextualAction(style: .normal, title: "Info") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let selectedItem = self.items[indexPath.row]
            self.removeExistingItem(itemID: selectedItem.id)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = ColorScheme.red
        deleteAction.image = Symbols.deleteTrailingSwipeSymbol
        
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
}

// MARK: - PassDataBackDelegate extension
extension MainViewController: PassDataBackDelegate {
    func updateExistingItem(withID itemID: String, changeTo item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == itemID }) {
            items[index] = item
            tableView.reloadData()
            updateCompletedLabel()
        }
    }
    
    func createNewItem(_ item: TodoItem) {
        items.append(item)
        tableView.reloadData()
        updateCompletedLabel()
    }
    
    func changeItemCompleteness(itemID: String) {
        if let index = items.firstIndex(where: { $0.id == itemID }) {
            items[index].isDone.toggle()
            tableView.reloadData()
            updateCompletedLabel()
        }
    }
    
    func removeExistingItem(itemID: String) {
        guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
        items.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        if index == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
        }
        updateCompletedLabel()
    }
}

// MARK: - Other functions extension
extension MainViewController {
    private func updateCompletedLabel() {
        let completedItems = items.reduce(0) { count, item in
            return count + (item.isDone ? 1 : 0)
        }
        completedLabel.text = "Completed - \(completedItems)"
    }
    
    private func changeItemPriority(withID itemID: String, to priority: Priority) {
        if let index = items.firstIndex(where: { $0.id == itemID }) {
            items[index].priority = priority
            tableView.reloadData()
            updateCompletedLabel()
        }
    }
}
