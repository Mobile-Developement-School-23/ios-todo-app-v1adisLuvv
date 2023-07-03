//
//  AddButton.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-03.
//

import UIKit

final class AddButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        backgroundColor = ColorScheme.blue
        layer.cornerRadius = 44 / 2
        layer.masksToBounds = false // allow the shadow to be visible outside the nds
        tintColor = ColorScheme.white
        
        let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
        setImage(plusImage, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        setupShadow()
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.systemBlue.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 44 / 8
    }
    
    func addTargetForAddButton(_ target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
    
}
