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
    
    private var ids = [String]()
    private var titles = [String]()
    private var details = [String]()
    private var isDones = [Bool]()
    private var isDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Auth.auth().currentUser {
            fetchUserName(user: user)
            fetchWithSearchAndSort(user: user)
        }
        
    }
    
    @IBAction private func addButtonDidTapped(_ sender: Any) {
        presentToDoAddVC()
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
    
    @IBAction private func segmentedControlDidChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
            case 0:
                isDone = false
                getToDoDataFromFirestore()
            case 1:
                isDone = true
                getToDoDataFromFirestore()
            default:
                isDone = false
                getToDoDataFromFirestore()
        }
    }
    
    private func getToDoDataFromFirestore() {
        if let user = Auth.auth().currentUser {
            let storeRef = Firestore.firestore().collection("users/\(user.uid)/todos")
            storeRef.whereField("isDone", isEqualTo: isDone).order(by: "createdAt").getDocuments { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    self.removeAll()
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        self.ids.append(doc.documentID)
                        self.titles.append(data["title"] as! String)
                        self.details.append(data["detail"] as! String)
                        self.isDones.append(data["isDone"] as! Bool)
                    }
                    self.tableView.reloadData()
                } else if error != nil {
                    print("ToDo情報取得失敗: ", error!.localizedDescription)
                }
            }
        }
    }
    
    private func fetchWithSearchAndSort(user: User) {
        let storeRef = Firestore.firestore().collection("users/\(user.uid)/todos")
        storeRef.whereField("isDone", isEqualTo: isDone).order(by: "createdAt").addSnapshotListener { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                self.removeAll()
                for doc in querySnapshot.documents {
                    let data = doc.data()
                    self.ids.append(doc.documentID)
                    self.titles.append(data["title"] as! String)
                    self.details.append(data["detail"] as! String)
                    self.isDones.append(data["isDone"] as! Bool)
                }
                self.tableView.reloadData()
            } else if error != nil {
                print("ToDo情報取得失敗: ", error!.localizedDescription)
            }
        }
    }
    
    private func removeAll() {
        self.ids.removeAll()
        self.titles.removeAll()
        self.details.removeAll()
        self.isDones.removeAll()
    }
        
    private func fetchUserName(user: User) {
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
    
    private func presentToDoAddVC() {
        let storyboard = UIStoryboard(name: "ToDoAdd", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "ToDoAddViewController"
        ) as! ToDoAddViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func presentVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "ViewController"
        ) as! ViewController
        present(vc, animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension ToDoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "ToDoEdit", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "ToDoEditViewController"
        ) as! ToDoEditViewController
        vc.id = ids[indexPath.row]
        vc.toDoTitle = titles[indexPath.row]
        vc.detail = details[indexPath.row]
        vc.isDone = isDones[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension ToDoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
}

// MARK: - setup
extension ToDoListViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

