//
//  ColorScheme.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-23.
//

import Foundation
import UIKit

// custom color scheme from assets
struct ColorScheme {
    
    // this colors 100% exists because i set the names so we can use force unwrap
    static let mainPrimaryBackground = UIColor(named: "MainPrimaryBackground")!
    static let detailPrimaryBackground = UIColor(named: "DetailPrimaryBackground")!
    static let secondaryBackground = UIColor(named: "SecondaryBackground")!
    
    static let primaryLabel = UIColor(named: "PrimaryLabel")!
    static let secondaryLabel = UIColor(named: "SecondaryLabel")!
    static let tertiaryLabel = UIColor(named: "TertiaryLabel")!
    static let disabledLabel = UIColor(named: "DisabledLabel")!
    
    static let red = UIColor(named: "Red")!
    static let green = UIColor(named: "Green")!
    static let blue = UIColor(named: "Blue")!
    static let gray = UIColor(named: "Gray")!
    static let lightGray = UIColor(named: "LightGray")!
    static let white = UIColor(named: "White")!
    
}
