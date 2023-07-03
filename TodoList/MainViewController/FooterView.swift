//
//  FooterView.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-03.
//

import UIKit
import SnapKit

final class FooterView: UIView {
    
    private var tableViewWidth: CGFloat
    private var footerHeight: CGFloat
    
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
        // tap
//        view.addGestureRecognizer(tap)
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
    
    init(frame: CGRect, tableViewWidth: CGFloat, footerHeight: CGFloat) {
        self.tableViewWidth = tableViewWidth
        self.footerHeight = footerHeight
        super.init(frame: frame)
    }
    
    convenience init(tableViewWidth: CGFloat, footerHeight: CGFloat) {
        let frame = CGRect(x: 0, y: 0, width: tableViewWidth, height: footerHeight)
        self.init(frame: frame, tableViewWidth: tableViewWidth, footerHeight: footerHeight)
        setupFooter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFooter() {
        backgroundColor = ColorScheme.mainPrimaryBackground
        
        addSubview(whiteView)
        addSubview(clearView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
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
    }
}
