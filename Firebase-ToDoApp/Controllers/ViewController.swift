//
//  ViewController.swift
//  Firebase-ToDoApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit

// 元コード: https://github.com/PictoMki/firestore_todo_app/tree/fix/mvc

final class ViewController: UIViewController {
    
    @IBOutlet private weak var registerEmailTextField: UITextField!
    @IBOutlet private weak var registerPasswordTextField: UITextField!
    @IBOutlet private weak var registerNameTextField: UITextField!
    @IBOutlet private weak var loginEmailTextField: UITextField!
    @IBOutlet private weak var loginPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func registerButtonDidTapped(_ sender: Any) {
        guard let email = registerEmailTextField.text,
              let password = registerPasswordTextField.text,
              let name = registerNameTextField.text else { return }
        User.registerUserToAuthentication(email: email, password: password) { user, error in
            if let user = user {
                User.createUserToFirestore(userId: user.uid, userName: name) { error in
                    if let error = error {
                        FuncUtil.showErrorDialog(error: error, title: "Firestore 新規登録失敗", vc: self)
                    } else {
                        self.presentToDoListVC()
                    }
                }
            } else if let error = error {
                FuncUtil.showErrorDialog(error: error, title: "Firebase Auth 新規登録失敗", vc: self)
            }
        }
    }
    
    @IBAction private func loginButtonDidTapped(_ sender: Any) {
        if let email = loginEmailTextField.text,
           let password = loginPasswordTextField.text {
            User.loginUserToAuthentication(email: email, password: password) { error in
                if let error = error {
                    FuncUtil.showErrorDialog(error: error, title: "ログイン失敗", vc: self)
                } else {
                    self.presentToDoListVC()
                }
            }
        }
    }
    
    private func presentToDoListVC() {
        let storyboard = UIStoryboard(name: "ToDoList", bundle: nil)
        let toDoListVC = storyboard.instantiateViewController(
            identifier: "ToDoListViewController"
        ) as! ToDoListViewController
        present(toDoListVC, animated: true)
    }
    
}

