//
//  DispatchQueue+Extension.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 11.03.21.
//

import Foundation

extension DispatchQueue {
    
    func async(after delay: TimeInterval, execute: @escaping () -> Void) {
        
        asyncAfter(deadline: .now() + delay, execute: execute)
    }
}

