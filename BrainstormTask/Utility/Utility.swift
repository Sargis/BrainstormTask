//
//  Utility.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 10.03.21.
//

import Foundation
import UIKit


class Utility {
    
    static func instantiate<T: UIViewController>(fromStoryboard viewControllerClass : T.Type) -> T {
        let identifier = NSStringFromClass(viewControllerClass).components(separatedBy: ".").last!
        let storyboard = UIStoryboard.init(name: identifier, bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            
            return controller
        }
        fatalError("Could not instantiate \(identifier) from storyboard")
    }
}
