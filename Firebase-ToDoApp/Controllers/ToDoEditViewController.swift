//
//  ToDoEditViewController.swift
//  Firebase-ToDoApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit
import Firebase

final class ToDoEditViewController: UIViewController {
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var detailTextView: UITextView!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var isDoneLabel: UILabel!
    
    var id: String!
    var toDoTitle: String!
    var detail: String!
    var isDone: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    @IBAction private func editButtonDidTapped(_ sender: Any) {
        guard let title = titleTextField.text,
              let detail = detailTextView.text else { return }
        if let user = Auth.auth().currentUser {
            let docData = ["title": title,
                           "detail": detail,
                           "updateAt": FieldValue.serverTimestamp()
            ] as [String : Any]
            let storeRef = Firestore.firestore().collection("users/\(user.uid)/todos")
            storeRef.document(id).updateData(docData) { error in
                if error != nil {
                    print("ToDo更新失敗: ", error!.localizedDescription)
                    return
                }
                print("ToDo更新成功")
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction private func doneButtonDidTapped(_ sender: Any) {
        if let user = Auth.auth().currentUser {
            let docData = ["isDone": !isDone,
                           "updateAt": FieldValue.serverTimestamp()
            ] as [String : Any]
            let storeRef = Firestore.firestore().collection("users/\(user.uid)/todos")
            storeRef.document(id).updateData(docData) { error in
                if error != nil {
                    print("ToDo更新失敗: ", error!.localizedDescription)
                    return
                }
                print("ToDo更新成功")
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction private func deleteButtonDidTapped(_ sender: Any) {
        if let user = Auth.auth().currentUser {
            let storeRef = Firestore.firestore().collection("users/\(user.uid)/todos")
            storeRef.document(id).delete() { error in
                if error != nil {
                    print("ToDo削除失敗: ", error!.localizedDescription)
                    return
                }
                print("ToDo削除成功")
                self.dismiss(animated: true)
            }
        }
    }
    
}

// MARK: - setup
private extension ToDoEditViewController {
    
    func setup() {
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
        titleTextField.text = toDoTitle
        detailTextView.text = detail
        isDoneLabel.text = isDone ? "完了" : "未完了"
        doneButton.setTitle({
            return isDone ? "未完了にする" : "完了済みにする"
        }(), for: .normal)
    }
    
}
