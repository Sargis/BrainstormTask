//
//  UsersViewController.swift
//  BrainstormTask
//
//  Created Sargis Khachatryan on 10.03.21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class UsersViewController: UIViewController {

	var presenter: UsersPresenterProtocol?

    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    fileprivate var refresher: IQPullToRefresh!
    fileprivate(set) var resultsTableController: UserSearchResultTableViewController!
   
	override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupTableViewInfinity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    fileprivate func setupTableViewInfinity() {
        self.refresher = IQPullToRefresh.init(scrollView: self.tableView, refresher: self, moreLoader: self)
        self.refresher.enablePullToRefresh = true
        self.refresher.enableLoadMore = true
        
        self.refresher.refresher?.refreshTriggered(type: .refreshControl, loadingBegin: { (begin) in
        }, loadingFinished: { (end) in
        })
        self.refresher.moreLoader?.loadMoreTriggered(type: .reachAtEnd, loadingBegin: { (bgin) in
            
        }, loadingFinished: { (end) in
            
        })
        self.refresher.beginPullToRefreshAnimation()
    }

    fileprivate func setup() {
        self.navigationItem.title = "Users"
        self.resultsTableController = Utility.instantiate(fromStoryboard: UserSearchResultTableViewController.self)
        self.resultsTableController.delegate = self
        self.searchController = UISearchController(searchResultsController: resultsTableController)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.autocapitalizationType = .none
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.autocapitalizationType = .none
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.tableView.register(cellNib: UserTableViewCell.self)
    }
    
    //MARK:- Actions
    @IBAction func segmentControlValueChangd(_ sender: UISegmentedControl) {
        self.presenter!.userDataType = UserDataType.init(rawValue: sender.selectedSegmentIndex) ?? .saved
        self.tableView.reloadSections([0], with: .automatic)
        
        self.refresher.enablePullToRefresh = self.presenter!.userDataType == .user
        self.refresher.enableLoadMore = self.presenter!.userDataType == .user
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.presenter!.userDataType == .user ?  self.presenter!.users.count : self.presenter!.savedUsers.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(cell: UserTableViewCell.self, for: indexPath)
        let user = self.presenter!.userDataType == .user ? self.presenter!.users[indexPath.row] : self.presenter!.savedUsers[indexPath.row]
        cell.update(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.didSelect(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension UsersViewController: Refreshable, MoreLoadable {
    
    func refreshTriggered(type: IQPullToRefresh.RefreshType, loadingBegin: @escaping (Bool) -> Void, loadingFinished: @escaping (Bool) -> Void) {
        loadingBegin(true)
        self.presenter?.pullToRefreshSwipe()
    }
    
    func loadMoreTriggered(type: IQPullToRefresh.LoadMoreType, loadingBegin: @escaping (Bool) -> Void, loadingFinished: @escaping (Bool) -> Void) {
        loadingBegin(true)
        self.presenter?.loadMoreSwipe()
    }
}

//MARK:- UsersViewProtocol

extension UsersViewController: UsersViewProtocol {
    
    func receivedError(_ error: Error) {
        self.refresher.endPullToRefreshAnimation()
        self.refresher.endLoadMoreAnimation()
        self.presentAlert(error.localizedDescription)
    }
    
    func updateUserList() {
        self.refresher.endPullToRefreshAnimation()
        self.refresher.endLoadMoreAnimation()
        self.tableView.reloadData()
    }
    
}

//MARK:- UserSearchResultTableViewControllerDelegate
extension UsersViewController: UserSearchResultTableViewControllerDelegate {
    
    func didSelectResult(_ controller: UserSearchResultTableViewController, user: User) {
        self.presenter?.didSelectSearchResult(user)
    }
}
