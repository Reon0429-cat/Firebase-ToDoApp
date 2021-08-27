//
//  ToDoAddViewController.swift
//  Firebase-ToDoApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit
import Firebase

final class ToDoAddViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        
    }
    
    @IBAction private func addButtonDidTapped(_ sender: Any) {
        if let title = titleTextField.text,
           let detail = detailTextView.text {
            if let user = Auth.auth().currentUser {
                let createdTime = FieldValue.serverTimestamp()
                let docData = ["title": title,
                               "detail": detail,
                               "isDone": false,
                               "createdAt": createdTime,
                               "updatedAt": createdTime
                ] as [String : Any]
                Firestore.firestore().collection("users/\(user.uid)/todos").document().setData(docData, merge: true) { error in
                    if error != nil {
                        print("ToDo作成失敗: ", error!.localizedDescription)
                        return
                    }
                    print("ToDo作成成功")
                    self.dismiss(animated: true)
                }
            }
        }
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

