//
//  String+Extension.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 11.03.21.
//

import Foundation
import UIKit

extension String {
    
    var url:URL? {
        if let string = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: string)
        }
        
        return nil
    }
}
