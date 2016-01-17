//
//  RouteListTVC.swift
//  Routes
//
//  Created by Marcone Magnus on 12/23/15.
//  Copyright © 2015 Marcone Magnus. All rights reserved.
//

import UIKit
import MBProgressHUD

class RouteListTVC: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Table view data source
    
    let routeCollection : RouteCollection = RouteCollection()

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeCollection.routes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.routeCollection.routes[indexPath.row].longName
        return cell
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
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.mode = .Indeterminate
        progressHUD.labelText = "Loading"
        self.routeCollection.findRoutes(withStopName: searchBar.text!) { error in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if let error = error {
                let errorDialog = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                errorDialog.addAction(dismissAction)
                self.presentViewController(errorDialog, animated: true, completion: nil)
            } else {
                 self.tableView.reloadData()
            }
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    // Mark:  segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RouteDetailSegue" {
            if let destination = segue.destinationViewController as? RouteDetailTVC {
                if let routeIndex = tableView.indexPathForSelectedRow?.row {
                    destination.currentRoute = self.routeCollection.routes[routeIndex]
                }
            }
        }
    }
    
}
