//
//  ToDoAddViewController.swift
//  Firebase-ToDoApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit

final class ToDoAddViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        
    }
    
    @IBAction private func addButtonDidTapped(_ sender: Any) {
        
    }
    
}

// MARK: - setup
private extension ToDoAddViewController {
    
    func setupTextView() {
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
    }
    
}
