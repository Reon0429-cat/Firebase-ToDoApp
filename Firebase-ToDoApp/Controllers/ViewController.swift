//
//  ViewController.swift
//  Firebase-ToDoApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit
import Firebase

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
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                print("ユーザー作成完了 uid:", user.uid)
                Firestore.firestore().collection("users").document(user.uid).setData(["name": name]) { error in
                    if let error = error {
                        print("Firestore 新規登録失敗", error.localizedDescription)
                        return
                    } else {
                        print("ユーザー作成完了 name:", name)
                        self.presentToDoListVC()
                    }
                }
            } else if let error = error {
                print("Firebase Auth 新規登録失敗", error.localizedDescription)
                return
            }
        }
    }
    
    @IBAction private func loginButtonDidTapped(_ sender: Any) {
        if let email = loginEmailTextField.text,
           let password = loginPasswordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let user = result?.user {
                    print("ログイン完了 uid:" + user.uid)
                    self.presentToDoListVC()
                } else if let error = error {
                    print("ログイン失敗 " + error.localizedDescription)
                    return
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

