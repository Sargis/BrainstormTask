//
//  User.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 10.03.21.
//

import Foundation
import RealmSwift
import SwiftyJSON

@objcMembers
class User: Object {
    
    dynamic var id: String = ""
    dynamic var pictureUrlString = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var gender: String = ""
    dynamic var phoneNumber: String = ""
    dynamic var address: String = ""
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
    convenience init(_ json: JSON) {
        self.init()
    }
    
    func clone() -> User{
        let user = User()
        user.id = self.id
        user.pictureUrlString = self.pictureUrlString
        user.firstName = self.firstName
        user.lastName = self.lastName
        user.gender = self.gender
        user.phoneNumber = self.phoneNumber
        user.address = self.address
        user.lat = self.lat
        user.lng = self.lng
        return user
    }
}
