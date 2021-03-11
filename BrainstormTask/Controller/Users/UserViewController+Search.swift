//
//  UserViewController+UISearchResultsUpdating.swift
//  BrainstormTask
//
//  Created by Sargis Khachatryan on 10.03.21.
//

import Foundation
import UIKit

//MARK:- UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegatev

extension UsersViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    private func findMatches(searchString: String) -> NSCompoundPredicate {
    
        var searchItemsPredicate = [NSPredicate]()
        
      
        let firstNameExpression = NSExpression(forKeyPath: "firstName")
        let firstNameSearchStringExpression = NSExpression(forConstantValue: searchString)
        
        let firstNameSearchComparisonPredicate =
            NSComparisonPredicate(leftExpression: firstNameExpression,
                                  rightExpression: firstNameSearchStringExpression,
                                  modifier: .direct,
                                  type: .contains,
                                  options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(firstNameSearchComparisonPredicate)
        
        
        let lastNameExpression = NSExpression(forKeyPath: "lastName")
        let lastNameStringExpression = NSExpression(forConstantValue: searchString)
        
        let lastNameSearchComparisonPredicate =
            NSComparisonPredicate(leftExpression: lastNameExpression,
                                  rightExpression: lastNameStringExpression,
                                  modifier: .direct,
                                  type: .contains,
                                  options: [.caseInsensitive, .diacriticInsensitive])
        
        
        searchItemsPredicate.append(lastNameSearchComparisonPredicate)
        
        
                
        var finalCompoundPredicate: NSCompoundPredicate!
    
        // Handle the scoping.
        let selectedScopeButtonIndex = searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex > 0 {
            // We have a scope type to narrow our search further.
            if !searchItemsPredicate.isEmpty {
                /** We have a scope type and other fields to search on -
                    so match up the fields of the Product object AND its product type.
                */
                let compPredicate1 = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
                let compPredicate2 = NSPredicate(format: "(SELF.type == %ld)", selectedScopeButtonIndex)

                finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [compPredicate1, compPredicate2])
            } else {
                // Match up by product scope type only.
                finalCompoundPredicate = NSCompoundPredicate(format: "(SELF.type == %ld)", selectedScopeButtonIndex)
            }
        } else {
            // No scope type specified, just match up the fields of the Product object
            finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        }

        //Swift.debugPrint("search predicate = \(String(describing: finalCompoundPredicate))")
        return finalCompoundPredicate
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        if strippedString.isEmpty {
            self.resultsTableController.users = []
            self.resultsTableController.tableView.reloadData()
        }
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }
        
        let finalCompoundPredicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)

        let users = self.presenter!.userDataType == .user ? self.presenter!.users : self.presenter!.savedUsers.map({$0.clone()})
        let filteredResults = users.filter { finalCompoundPredicate.evaluate(with: $0) }
        
        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? UserSearchResultTableViewController {
            resultsController.users = filteredResults
            resultsController.tableView.reloadSections([0], with: .automatic) {
                resultsController.tableView.reloadData()
            }
        }
    }
}
