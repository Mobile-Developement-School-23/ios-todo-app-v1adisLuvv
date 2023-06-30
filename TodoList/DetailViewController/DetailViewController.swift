//
//  DetailViewController.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-17.
//

import UIKit
import SnapKit
import FileCache

final class DetailViewController: UIViewController {
    
    // MARK: - Variables
    weak var delegate: PassDataBackDelegate?
    private let fileName = "firstTodoItem" // file where the TodoItem will be saved
    
    private let currentItem: TodoItem?
    
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
        view.addSubview(scrollView)
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
        if let text = text {
            textView.text = text
            textView.textColor = ColorScheme.primaryLabel
        } else {
            textView.text = "What to do?"
            textView.textColor = ColorScheme.tertiaryLabel
        }
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
        return button
    }()
    
    init(currentItem: TodoItem? = nil) {
        self.currentItem = currentItem
        super.init(nibName: nil, bundle: nil)
        if let currentItem = currentItem {
            self.id = currentItem.id
            self.text = currentItem.text
            self.priority = currentItem.priority
            self.deadline = currentItem.deadline
        } else {
            saveButton.isEnabled = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = ColorScheme.detailPrimaryBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupNavigationBar()
        
        setupConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait {
            tableView.isHidden = false
            removeButton.isHidden = false
            
            taskTextView.snp.updateConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.width.equalToSuperview()
                make.height.greaterThanOrEqualTo(120)
            }
        }
        
        if UIDevice.current.orientation.isLandscape {
            tableView.isHidden = true
            removeButton.isHidden = true
            
            taskTextView.snp.updateConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.width.equalToSuperview()
                make.height.greaterThanOrEqualTo(view.bounds.height)
            }
        }
    }
    
    // MARK: - setupNavigationBar
    private func setupNavigationBar() {
        let navigationItem = UINavigationItem()
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        navigationBar.barTintColor = ColorScheme.detailPrimaryBackground
        
        navigationBar.setItems([navigationItem], animated: false)
        
        view.addSubview(navigationBar)
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
        dismiss(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        let item = TodoItem(id: id ?? UUID().uuidString, text: text ?? "", priority: priority, deadline: deadline)
        if currentItem != nil {
            delegate?.updateExistingItem(item)
        } else {
            delegate?.createNewItem(item)
        }
        dismiss(animated: true)
    }
    
    @objc private func didTapRemoveButton() {
        if currentItem != nil {
            delegate?.removeExistingItem()
            dismiss(animated: true)
        } else {
            didTapSaveButton()
        }
    }
}

// MARK: - UITextViewDelegate extension
extension DetailViewController: UITextViewDelegate {
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
extension DetailViewController: UITableViewDelegate {
    
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
                
            } else {
                self.tableView.snp.updateConstraints { make in
                    make.height.equalTo(56 * 2 - 1)
                }
                
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
extension DetailViewController: UITableViewDataSource {
    
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
extension DetailViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let dateComponents = dateComponents, let date = Calendar.current.date(from: dateComponents) {
            deadline = date
        }
    }
}

extension DetailViewController: DidChangePriorityDelegate {
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

extension DetailViewController: DidToggleDeadlineSwitchDelegate {
    func didToggleDeadlineSwitch(isOn: Bool) {
        if isOn {
            deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        } else {
            deadline = nil
        }
    }
}


// MARK: - Keyboard extension
extension DetailViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.snp.updateConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardSize.height + view.safeAreaInsets.bottom)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue != nil {
            scrollView.snp.updateConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
