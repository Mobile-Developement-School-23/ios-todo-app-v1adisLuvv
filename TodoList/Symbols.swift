//
//  Symbols.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-23.
//

import Foundation
import UIKit

struct Symbols {
    
    private static let arrowDownSymbolConfig = UIImage.SymbolConfiguration(weight: .bold)
    
    static let arrowDownSymbol = UIImage(systemName: "arrow.down", withConfiguration: arrowDownSymbolConfig)!.withTintColor(ColorScheme.gray, renderingMode: .alwaysOriginal)
    
    private static let doubleExclamationMarkSymbolConfig = UIImage.SymbolConfiguration(weight: .bold)
    
    static let doubleExclamationMarkSymbol = UIImage(systemName: "exclamationmark.2", withConfiguration: doubleExclamationMarkSymbolConfig)!.withTintColor(ColorScheme.red, renderingMode: .alwaysOriginal)
    
}
