//
//  Results+Extnsion.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 11.03.21.
//

import Foundation
import RealmSwift


extension Results {
    
    func safeObserve(_ block: @escaping (RealmCollectionChange<Results>) -> Void, completion: @escaping (NotificationToken) -> Void) {
        
        let realm = try! Realm()
        if (!realm.isInWriteTransaction) {
            let token = self.observe(block)
            completion(token)
        } else {
            DispatchQueue.main.async(after: 0.1) {
                self.safeObserve(block, completion: completion)
            }
        }
    }
}

