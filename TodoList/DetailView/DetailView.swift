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
    var text: String?
    var priority: Priority = .regular
    var deadline: Date? {
        didSet {
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
    
    
    private var showCalendar = false

    // MARK: - Constants
    private struct Constants {
        // some costants
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
    
    private lazy var contentView: UIView = {
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
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorScheme.detailPrimaryBackground
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
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

}

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
        text = textView.text
    }
}

extension DetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 332
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
        
        UIView.animate(withDuration: 1.0, animations: { [weak self] in
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

extension DetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showCalendar ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PriorityTableViewCell.identifier, for: indexPath) as? PriorityTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.identifier, for: indexPath) as? DeadlineTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            cell.configureDeadline(withDate: deadline)
            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
}

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
        print(priority)
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