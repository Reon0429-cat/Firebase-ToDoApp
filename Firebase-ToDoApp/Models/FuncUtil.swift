//
//  FuncUtil.swift
//  Firebase-ToDoApp
//
//  Created by 大西玲音 on 2021/08/27.
//

import UIKit

final class FuncUtil {
    
    static func showErrorDialog(error: Error, title: String, vc: UIViewController) {
        print(title + error.localizedDescription)
        let dialog = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(dialog, animated: true)
    }
    
}
