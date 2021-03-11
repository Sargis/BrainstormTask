//
//  RalmExtnsion.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 11.03.21.
//

import RealmSwift

extension Realm {
    
    func safeWrite(_ block:@escaping (() throws -> Void)) throws {
        try autoreleasepool {
            if (isInWriteTransaction) {
                DispatchQueue.main.async(after: 0.1) {
                   try? self.safeWrite(block)
                }
            } else {
                try write(block)
            }
        }
    }
    
}
