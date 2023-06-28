//
//  DetailView.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-20.
//

import UIKit
import SnapKit

final class DetailView: UIView {
    
    // MARK: - Variables
    private let fileName = "firstTodoItem" // file where the TodoItem will be written
    
    private var id: String?
    private var text: String?
    private var priority: Priority = .regular
    private var deadline: Date? {
        didSet {
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
    
    private var showCalendar = false

    // MARK: - Constants
    private struct Constants {
        // layout constants will be added here later...
    }
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = ColorScheme.detailPrimaryBackground
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = { // the UIView stretched all over the scrollView
        let contentView = UIView()
        contentView.backgroundColor = ColorScheme.detailPrimaryBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        return contentView
    }()
    
    private lazy var taskTextView: UITextView = {
        let textView = UITextView()
        textView.text = "What to do?"
        textView.textColor = ColorScheme.tertiaryLabel
        textView.font = .systemFont(ofSize: 17)
        textView.backgroundColor = ColorScheme.secondaryBackground
        textView.layer.cornerRadius = 16
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        return textView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(PriorityTableViewCell.self, forCellReuseIdentifier: PriorityTableViewCell.identifier)
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: DeadlineTableViewCell.identifier)
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        return tableView
    }()
    
    private lazy var removeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Remove"
        config.background.cornerRadius = 16
        config.baseForegroundColor = ColorScheme.red
        config.baseBackgroundColor = ColorScheme.secondaryBackground
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }()
    
    private let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        return button
    }()
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorScheme.detailPrimaryBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupNavigationBar()
        
        loadTodoItem()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupNavigationBar
    private func setupNavigationBar() {
        let navigationItem = UINavigationItem()
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        navigationBar.barTintColor = ColorScheme.detailPrimaryBackground
        
        navigationBar.setItems([navigationItem], animated: false)
        
        addSubview(navigationBar)
    }
    
    // MARK: - loadTodoItem
    private func loadTodoItem() {
        let fileCache = FileCache.shared
        fileCache.loadJSONFromFile(fileName: fileName)
        guard let todoItem = fileCache.todoItems.first else { return }
        
        id = todoItem.id
        taskTextView.text = todoItem.text
        taskTextView.textColor = ColorScheme.primaryLabel
        priority = todoItem.priority
        deadline = todoItem.deadline
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalTo(scrollView.snp.width).inset(16)
        }
        
        taskTextView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(120)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(taskTextView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56*2 - 1)
        }
        
        removeButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(56)
        }
    }
    
    // MARK: - UI Interactions handling
    @objc private func didTapCancelButton() {
        taskTextView.text = "What to do?"
        taskTextView.textColor = ColorScheme.tertiaryLabel
    }
    
    @objc private func didTapSaveButton() {
        let todoItem = TodoItem(id: id ?? UUID().uuidString, text: text ?? "", priority: priority, deadline: deadline)
        let fileCache = FileCache.shared
        fileCache.addTask(todoItem)
        fileCache.saveJSONToFile(fileName: fileName)
    }
    
    @objc private func didTapRemoveButton() {
        let fileCache = FileCache.shared
        fileCache.removeTask(withID: id ?? "")
        fileCache.saveJSONToFile(fileName: fileName)
    }

}

// MARK: - UITextViewDelegate extension
extension DetailView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == ColorScheme.tertiaryLabel {
            textView.text = nil
            textView.textColor = ColorScheme.primaryLabel
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What to do?"
            textView.textColor = ColorScheme.tertiaryLabel
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = !textView.text.isEmpty
        text = textView.text
    }
}

// MARK: - UITableViewDelegate extension
extension DetailView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 332 // the row for the calendar
        } else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            showCalendar.toggle()
            calendarAnimation(isVisible: showCalendar)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func calendarAnimation(isVisible: Bool) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if isVisible {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .none)
                self.tableView.endUpdates()
                self.tableView.reloadData()
            }
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            if isVisible {
                self.tableView.snp.updateConstraints { make in
                    make.height.equalTo(56 * 2 - 1 + 332)
                }
                
                self.layoutIfNeeded()
            } else {
                self.tableView.snp.updateConstraints { make in
                    make.height.equalTo(56 * 2 - 1)
                }
                
                self.layoutIfNeeded()
            }
        }) { [weak self] _ in
            guard let self = self else { return }
            if !isVisible {
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .none)
                    self.tableView.endUpdates()
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource extension
extension DetailView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showCalendar ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PriorityTableViewCell.identifier, for: indexPath) as? PriorityTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.delegate = self
            cell.configurePriority(withPriority: priority)
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.identifier, for: indexPath) as? DeadlineTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            cell.configureDeadline(withDate: deadline)
            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
}


// MARK: - TableView cell delegates
extension DetailView: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let dateComponents = dateComponents, let date = Calendar.current.date(from: dateComponents) {
            deadline = date
        }
    }
}

extension DetailView: DidChangePriorityDelegate {
    func didChangePriority(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            priority = .low
        case 1:
            priority = .regular
        case 2:
            priority = .high
        default:
            break
        }
    }
}

extension DetailView: DidToggleDeadlineSwitchDelegate {
    func didToggleDeadlineSwitch(isOn: Bool) {
        if isOn {
            deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        } else {
            deadline = nil
        }
    }
}


// MARK: - Keyboard extension
extension DetailView {
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.snp.updateConstraints { make in
                make.bottom.equalTo(safeAreaLayoutGuide).offset(-keyboardSize.height + safeAreaInsets.bottom)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.snp.updateConstraints { make in
                make.bottom.equalTo(safeAreaLayoutGuide)
            }
        }
    }
}
