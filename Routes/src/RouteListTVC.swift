//
//  RouteListTVC.swift
//  Routes
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Marcone Magnus
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import MBProgressHUD
/**
 Responsible to integrate a table view with the route collection,  and handle the search bar requests.
*/
class RouteListTVC: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Table view data source
    
    /// The collection of routes.
    let routeCollection : RouteCollection = RouteCollection()

    /**
     Returns the number of section on table view. (Always 1)
     - parameter tableView:     The table view.
     - returns :                Number of section of the table view.
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /**
     Calculates the number of rows needed for a route collection.
     - parameter tableView:                        the table view.
     - parameter numberOfRowsInSection section:    the section index.
     - returns:                                    The number of rows needed.
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeCollection.routes.count
    }
    
    /**
     Assembles the cell for a row in the table view.
     - parameter tableView:                           the table view.
     - parameter cellForRowAtIndexPath indexPath:     row's index.
     - returns:                                       The table view cell for the row's index.
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.routeCollection.routes[indexPath.row].longName
        return cell
    }
    
    // MARK: - search bar delegate
    
    /**
    Handles when text begins to be edited.
    - parameter searchBar:     the search bar component.
    */
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    /**
     Handles cancel button press.
     - parameter searchBar:     The search bar component.
     */
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    /**
     Handle the search button press.
     - parameter searchBar:     The search bar component.
     */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.mode = .Indeterminate
        progressHUD.labelText = "Loading"

        /*
        If you had given findRoutes two separate callbacks for success and failure, you could avoid checking for error before handling the success case.
        It would improve clarity and simplify the logic
        */

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
    /**
    Prepare for segue to another view controller.
    - parameter segue:           The storyboard segue;
    - parameter sender:          component that trigger the segue.
    */
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
