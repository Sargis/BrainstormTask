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
    
    var isSaved: Bool {
        let realm = try! Realm.init()
        let user = realm.objects(User.self).filter(NSPredicate.init(format: "id == %@", self.id)).first
        return user != nil
    }
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
    convenience init(_ json: JSON) {
        self.init()
        self.id = json["login"]["uuid"].stringValue
        self.pictureUrlString = json["picture"]["thumbnail"].stringValue
        self.firstName = json["name"]["first"].stringValue
        self.lastName = json["name"]["last"].stringValue
        self.gender = json["gender"].stringValue
        self.phoneNumber = json["phone"].stringValue
        self.address = "\(json["location"]["country"].stringValue) \(json["location"]["postcode"].stringValue) \(json["location"]["city"].stringValue)"
        self.lat = json["location"]["coordinates"]["latitude"].doubleValue
        self.lng = json["location"]["coordinates"]["longitude"].doubleValue
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
    
    func setSavedUser() {
        let realm = try! Realm()
        try! realm.safeWrite {
            realm.create(User.self, value: self, update: .all)
        }
    }
    
    func removFromSavedUser() {
        let realm = try! Realm()
        if let temp = realm.objects(User.self).filter(NSPredicate.init(format: "id == %@", self.id)).first{
            try? realm.safeWrite {
                realm.delete(temp)
            }
        }
    }
}
