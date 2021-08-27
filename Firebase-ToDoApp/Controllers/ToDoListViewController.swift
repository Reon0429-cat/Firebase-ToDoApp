//
//  ToDoListViewController.swift
//  Firebase-ToDoApp
//
//  Created by 大西玲音 on 2021/08/26.
//

import UIKit
import Firebase

final class ToDoListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).getDocument { snapshot, error in
                if let snapshot = snapshot {
                    if let data = snapshot.data() {
                        self.userNameLabel.text = data["name"] as? String
                    }
                } else if let error = error {
                    print("ユーザー名取得失敗: " + error.localizedDescription)
                }
            }
        }
        
    }
    
    @IBAction private func addButtonDidTapped(_ sender: Any) {
    }
    
    @IBAction private func logoutButtonDidTapped(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            // ログイン済みでない場合はAuthのログイン情報が切れているので、再度ログインお願いしますアラートを表示
        } else {
            do {
                try Auth.auth().signOut()
                print("ログアウト完了")
                presentVC()
            } catch let error {
                print("ログアウト失敗", error.localizedDescription)
                return
            }
        }
    }
    
    @IBAction private func segmentedControlDidChanged(_ sender: Any) {
    }
    
    private func presentVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "ViewController"
        ) as! ViewController
        present(vc, animated: true)
    }
    
}
