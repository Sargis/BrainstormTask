//
//  UsersPresenter.swift
//  BrainstormTask
//
//  Created Sargis Khachatryan on 10.03.21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SwiftyJSON
import RealmSwift

enum UserDataType: Int {
    case user
    case saved
}

class UsersPresenter: UsersPresenterProtocol {

    weak private var view: UsersViewProtocol?
    var interactor: UsersInteractorInputProtocol?
    private let router: UsersWireframeProtocol

    var currentPageNumber: Int
    var users: [User]
    var savedUsers: Results<User>
    var userDataType: UserDataType
    private var tokenUser: NotificationToken? = nil
    
    init(interface: UsersViewProtocol, interactor: UsersInteractorInputProtocol?, router: UsersWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
        self.currentPageNumber = 1
        self.users = []
        self.userDataType = .user
        
        let realm = try! Realm()
        self.savedUsers = realm.objects(User.self)
        self.tokenUser?.invalidate()
        
        self.savedUsers.safeObserve { (changes) in
            print("realm changed notification")
        } completion: { (token) in
            self.tokenUser = token
        }
    }

    func pullToRefreshSwipe() {
        self.currentPageNumber = 1
        self.interactor?.getUserData(self.currentPageNumber)
    }
    
    func loadMoreSwipe() {
        self.currentPageNumber += 1
        self.interactor?.getUserData(self.currentPageNumber)
    }
    
    func didSelect(_ index: Int) {
        let user = self.userDataType == .user ? self.users[index] : self.savedUsers[index]
        self.router.pushToUserDtail(user)
    }
    
    func didSelectSearchResult(_ user: User) {
        self.router.pushToUserDtail(user)
    }
}

//MARK:- UsersInteractorOutputProtocol
extension UsersPresenter: UsersInteractorOutputProtocol {
    
    func rceivedUserData(_ json: JSON?, error: Error?) {
        
        if let json = json {
            self.view?.updateUserList()
            let users = json["results"].arrayValue.map({User.init($0)})
            if self.currentPageNumber == 1 {
                self.users = users
            } else {
                self.users.append(contentsOf: users)
            }
        }
        
        if let error = error {
            self.view?.receivedError(error)
        }
    }
}
