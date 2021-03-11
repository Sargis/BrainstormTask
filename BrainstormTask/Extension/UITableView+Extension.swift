//
//  UITableView+Extension.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 10.03.21.
//

import Foundation
import UIKit

extension UITableView {
    
    func cell<T: UITableViewCell>(cell class : T.Type, for indexPath: IndexPath) -> T {
        if let cell = self.dequeueReusableCell(withIdentifier: `class`.nameOfClass, for: indexPath) as? T {
            return cell
        }
        fatalError("Could not load cell \(`class`) from nib")
    }
    
    func register<T: UITableViewCell>(cellNib class : T.Type) {
        let nib = UINib.init(nibName: `class`.nameOfClass, bundle: nil)
        self.register(nib, forCellReuseIdentifier: `class`.nameOfClass)
    }
    
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation, completion: @escaping ()->()) {
        CATransaction.begin()
        self.beginUpdates()
        CATransaction.setCompletionBlock(completion)
        self.reloadSections(sections, with: animation)
        self.endUpdates()
        CATransaction.commit()
    }
}

