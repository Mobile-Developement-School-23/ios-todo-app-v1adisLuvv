//
//  MainViewController.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-27.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    override func loadView() {
        let mainView = MainView()
        view = mainView
        setupNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
