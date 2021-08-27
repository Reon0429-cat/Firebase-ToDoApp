//
//  User.swift
//  Firebase-ToDoApp
//
//  Created by 大西玲音 on 2021/08/27.
//

import UIKit
import Firebase
final class User {
    var id: String
    var name: String
    
    init(doc: DocumentSnapshot) {
        self.id = doc.documentID
        let data = doc.data()
        self.name = data!["name"] as! String
    }
    
    static func registerUserToAuthentication(email: String,
                                             password: String,
                                             completion: @escaping (Firebase.User?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(result?.user, nil)
            }
        }
    }
    
    static func createUserToFirestore(userId: String,
                                      userName: String,
                                      completion: @escaping (Error?) -> Void) {
        Firestore.firestore().collection("users").document(userId).setData(["name": userName]) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    static func loginUserToAuthentication(email: String,
                                          password: String,
                                          completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    static func getUserDataFromFirestore(completion: @escaping (User?, Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).getDocument { snapshot, error in
                if let snapshot = snapshot {
                    let user = User(doc: snapshot)
                    completion(user, nil)
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
    }
    
}
