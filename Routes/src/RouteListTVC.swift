//
//  RouteListTVC.swift
//  Routes
//
//  Created by Marcone Magnus on 12/23/15.
//  Copyright © 2015 Marcone Magnus. All rights reserved.
//

import UIKit

class RouteListTVC: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // MARK: - search bar delegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let apiFetcher = APIDataFetcher()
        apiFetcher.findRoutes(byStopName: searchBar.text!)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
    }
    
}
