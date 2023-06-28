//
//  Symbols.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-23.
//

import Foundation
import UIKit

// struct with symbols inside the segmented control (arrow down and double exclamation mark)
struct Symbols {
    
    // this symbols 100% exists because this is the systemName so we can use force unwrap
    private static let arrowDownSymbolConfig = UIImage.SymbolConfiguration(weight: .bold)
    
    static let arrowDownSymbol = UIImage(systemName: "arrow.down", withConfiguration: arrowDownSymbolConfig)!.withTintColor(ColorScheme.gray, renderingMode: .alwaysOriginal)
    
    private static let doubleExclamationMarkSymbolConfig = UIImage.SymbolConfiguration(weight: .bold)
    
    static let doubleExclamationMarkSymbol = UIImage(systemName: "exclamationmark.2", withConfiguration: doubleExclamationMarkSymbolConfig)!.withTintColor(ColorScheme.red, renderingMode: .alwaysOriginal)
    
    
    
    
    private static let regularTaskButtonSymbolConfig = UIImage.SymbolConfiguration(weight: .regular)
    
    static let regularTaskButtonSymbol = UIImage(systemName: "circle", withConfiguration: regularTaskButtonSymbolConfig)!.withTintColor(ColorScheme.lightGray, renderingMode: .alwaysOriginal)
    
    private static let highPriorityTaskButtonSymbolConfig = UIImage.SymbolConfiguration(weight: .regular)
    
    static let highPriorityTaskButtonSymbol = UIImage(systemName: "circle", withConfiguration: highPriorityTaskButtonSymbolConfig)!.withTintColor(ColorScheme.red, renderingMode: .alwaysOriginal)
    
    private static let checkedTaskButtonSymbolConfig = UIImage.SymbolConfiguration(weight: .bold)
    
    static let checkedTaskButtonSymbol = UIImage(systemName: "checkmark.circle.fill", withConfiguration: checkedTaskButtonSymbolConfig)!.withTintColor(ColorScheme.green, renderingMode: .alwaysOriginal)
    
    
    
    private static let tableViewDisclosureSymbolConfig = UIImage.SymbolConfiguration(weight: .medium)
    
    static let tableViewDisclosureSymbol = UIImage(systemName: "chevron.forward", withConfiguration: tableViewDisclosureSymbolConfig)!.withTintColor(ColorScheme.gray, renderingMode: .alwaysOriginal)
}
