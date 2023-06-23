//
//  CalendarTableViewCell.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-22.
//

import UIKit
import SnapKit

final class CalendarTableViewCell: UITableViewCell {

    static let identifier = "CalendarTableViewCell"
    
    weak var delegate: UICalendarSelectionSingleDateDelegate? {
        didSet {
            calendar.selectionBehavior = UICalendarSelectionSingleDate(delegate: delegate)
        }
    }
    
    // MARK: - UI Elements
    private lazy var calendar: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.timeZone = .current
        calendarView.fontDesign = .rounded
        calendarView.availableDateRange = DateInterval(start: .now, end: .distantFuture)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(calendarView)
        return calendarView
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
        
        calendar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
    }
}
