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

class UsersPresenter: UsersPresenterProtocol, UsersInteractorOutputProtocol {

    weak private var view: UsersViewProtocol?
    var interactor: UsersInteractorInputProtocol?
    private let router: UsersWireframeProtocol

    init(interface: UsersViewProtocol, interactor: UsersInteractorInputProtocol?, router: UsersWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
