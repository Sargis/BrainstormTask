//
//  NSObject+Extension.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 10.03.21.
//

import Foundation

extension NSObject{
    
    class var nameOfClass: String{
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}


