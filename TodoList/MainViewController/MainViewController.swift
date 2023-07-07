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
    
    private var isDirty = false
    
    // MARK: - UI Elements
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = ColorScheme.primaryLabel
        return indicator
    }()
    
    
    private lazy var tableView: TasksTableView = {
        let tableView = TasksTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var addButton: AddButton = {
        let addButton = AddButton()
        addButton.addTargetForAddButton(self, action: #selector(didTapAddButton))
        return addButton
    }()
    
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView(tableViewWidth: tableView.bounds.width, headerHeight: 40)
        headerView.addTargetForShowHideButton(self, action: #selector(didTapShowHideButton))
        return headerView
    }()
    
    private lazy var footerView: FooterView = {
        let footerView = FooterView(tableViewWidth: tableView.bounds.height, footerHeight: 56 + 86)
        footerView.addTapGestureRecognizer(self, action: #selector(didTapAddButton))
        return footerView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorScheme.mainPrimaryBackground
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        loadTodoItems()
        setupConstraints()
        setupNavigationBar()
    }
    
    private func loadTodoItems() {
        Task {
            do {
                let elements = try await DefaultNetworkingService.loadList()
                let loadedItems = TodoItemConverter.convertServerListToTodoItemsList(elements)
                items = loadedItems
                tableView.reloadData()
                headerView.updateCompletedLabel(items: items)
                activityIndicator.stopAnimating()
            } catch {
                activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "Unable to fetch data", message: "Bad internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true)
            }
        }
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
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
        headerView.showCompletedItems.toggle()
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
                    cell.markTaskAsDone(item.isDone, isHighPriority: item.priority == .important, hasDeadline: item.deadline != nil)
                    self.headerView.updateCompletedLabel(items: self.items)
                }
            }
            
            let checkAsIncompletedAction = UIAction(title: "Incomplete", image: Symbols.regularTaskButtonSymbol) { _ in
                if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                    let item = self.items[indexPath.row]
                    self.changeItemCompleteness(itemID: item.id)
                    cell.markTaskAsDone(item.isDone, isHighPriority: item.priority == .important, hasDeadline: item.deadline != nil)
                    self.headerView.updateCompletedLabel(items: self.items)
                }
            }
            
            let makeImportantAction = UIAction(title: "Mark as important", image: Symbols.doubleExclamationMarkSymbol) { _ in
                let item = self.items[indexPath.row]
                self.changeItemPriority(withID: item.id, to: .important)
            }
            
            let makeRegularAction = UIAction(title: "Mark as basic") { _ in
                let item = self.items[indexPath.row]
                self.changeItemPriority(withID: item.id, to: .basic)
            }
            
            let makeLowAction = UIAction(title: "Mark as unimportant", image: Symbols.arrowDownSymbol) { _ in
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
            } else if self.items[indexPath.row].priority == .basic {
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
        if headerView.showCompletedItems {
            return items.count
        } else {
            return items.filter { !$0.isDone }.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        
        var filteredItems: [TodoItem]
        if headerView.showCompletedItems {
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
                cell.markTaskAsDone(item.isDone, isHighPriority: item.priority == .important, hasDeadline: item.deadline != nil)
                self.headerView.updateCompletedLabel(items: self.items)
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
            isDirty = true
            items[index] = item
            tableView.reloadData()
            headerView.updateCompletedLabel(items: items)
            Task {
                do {
                    activityIndicator.startAnimating()
                    let elementToSend = TodoItemConverter.convertTodoItemToServerElement(item)
                    let receivedElement = try await DefaultNetworkingService.updateItem(itemID: itemID, withItem: elementToSend)
                    items[index] = TodoItemConverter.convertServerElementToTodoItem(receivedElement)
                    isDirty = false
                    activityIndicator.stopAnimating()
                } catch NetworkError.retryFailed {
                    loadTodoItems() // if multiple retries failed we update the list with actual list from server
                    activityIndicator.stopAnimating()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func createNewItem(_ item: TodoItem) {
        isDirty = true
        items.append(item)
        tableView.reloadData()
        headerView.updateCompletedLabel(items: items)
        Task {
            do {
                activityIndicator.startAnimating()
                let elementToSend = TodoItemConverter.convertTodoItemToServerElement(item)
                _ = try await DefaultNetworkingService.uploadItem(item: elementToSend)
                isDirty = false
                activityIndicator.stopAnimating()
            } catch NetworkError.retryFailed {
                loadTodoItems() // if multiple retries failed we update the list with actual list from server
                activityIndicator.stopAnimating()
            } catch {
                print(error)
            }
        }
    }
    
    func changeItemCompleteness(itemID: String) {
        if let index = items.firstIndex(where: { $0.id == itemID }) {
            isDirty = true
            items[index].isDone.toggle()
            let item = items[index]
            tableView.reloadData()
            headerView.updateCompletedLabel(items: items)
            Task {
                do {
                    activityIndicator.startAnimating()
                    let elementToSend = TodoItemConverter.convertTodoItemToServerElement(item)
                    let receivedElement = try await DefaultNetworkingService.updateItem(itemID: itemID, withItem: elementToSend)
                    items[index] = TodoItemConverter.convertServerElementToTodoItem(receivedElement)
                    isDirty = false
                    activityIndicator.stopAnimating()
                } catch NetworkError.retryFailed {
                    loadTodoItems() // if multiple retries failed we update the list with actual list from server
                    activityIndicator.stopAnimating()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func removeExistingItem(itemID: String) {
        guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
        isDirty = true
        items.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        headerView.updateCompletedLabel(items: items)
        Task {
            do {
                activityIndicator.startAnimating()
                try await DefaultNetworkingService.deleteItem(itemID: itemID)
                isDirty = false
                activityIndicator.stopAnimating()
            } catch NetworkError.retryFailed {
                loadTodoItems() // if multiple retries failed we update the list with actual list from server
                activityIndicator.stopAnimating()
            } catch {
                print(error)
            }
        }
        if index == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
        }
    }
}

// MARK: - Other functions extension
extension MainViewController {
    
    private func changeItemPriority(withID itemID: String, to priority: Priority) {
        if let index = items.firstIndex(where: { $0.id == itemID }) {
            isDirty = true
            items[index].priority = priority
            let item = items[index]
            tableView.reloadData()
            headerView.updateCompletedLabel(items: items)
            Task {
                do {
                    activityIndicator.startAnimating()
                    let elementToSend = TodoItemConverter.convertTodoItemToServerElement(item)
                    let receivedElement = try await DefaultNetworkingService.updateItem(itemID: itemID, withItem: elementToSend)
                    items[index] = TodoItemConverter.convertServerElementToTodoItem(receivedElement)
                    isDirty = false
                    activityIndicator.stopAnimating()
                } catch NetworkError.retryFailed {
                    loadTodoItems() // if multiple retries failed we update the list with actual list from server
                    activityIndicator.stopAnimating()
                } catch {
                    print(error)
                }
            }
        }
    }
}
