//
//  UIViewController+Extension.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 11.03.21.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message : String, handler : (()->Void)? = nil) {
        self.present(AlertController.alert(title: title, message: message, completion: handler), animated: true, completion: nil)
    }
    
    func presentAlert(_ message : String, handler : (()->Void)? = nil) {
        self.present(AlertController.alert(title: nil, message: message, completion: handler), animated: true, completion: nil)
    }
}
