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
    
    let routeCollection : RouteCollection = RouteCollection()

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeCollection.routes.count
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
        self.routeCollection.findRoutes(withStopName: searchBar.text!)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
    }
    
}
