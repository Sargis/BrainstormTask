//
//  UserDetailRouter.swift
//  BrainstormTask
//
//  Created Sargis Khachatryan on 11.03.21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class UserDetailRouter: UserDetailWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    private init() {}
    
    static func createModule(_ user: User) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = Utility.instantiate(fromStoryboard: UserDetailViewController.self)
        let interactor = UserDetailInteractor()
        let router = UserDetailRouter()
        let presenter = UserDetailPresenter(interface: view, interactor: interactor, router: router, user: user)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
