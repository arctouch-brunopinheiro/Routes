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
    
}
