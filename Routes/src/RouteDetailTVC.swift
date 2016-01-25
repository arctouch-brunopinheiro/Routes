//
//  RouteDetailTVC.swift
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
 Responsible to integrate a table view with the departures and stops collection.
 */
class RouteDetailTVC: UITableViewController {
    
    /// Current selected route.
    var currentRoute : Route?
    
    /// The Departures collection.
    let departures = DepartureCollection()
    
    /// The Stops colection.
    let routeStopCollection = RouteStopCollection()

    /// The route name label outlet.
    @IBOutlet weak var routeName: UILabel!
    
    /// The modified date label outlet.
    @IBOutlet weak var modifiedLabel: UILabel!
    
    /// The stop list label outlet.
    @IBOutlet weak var stopListLabel: UILabel!
    
    /// The departures list label outlet.
    @IBOutlet weak var departureListLabel: UILabel!
    
    /// the day tyoe segment control outlet.
    @IBOutlet weak var dayTypeSegmentController: UISegmentedControl!
    
    /// The route detail table view initializer.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Called when the view is about to appear.
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.estimatedRowHeight = 100.0;
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = .MediumStyle
        routeName.text = currentRoute?.longName
        if let date = self.currentRoute?.lastModifiedDate {
            modifiedLabel.text = "Last Modified: " + dateFormater.stringFromDate(date)
        }
        self.loadStops()
        self.loadDepartures()
    }
    
    /**
     Handle the segment control index changes changes
     */
    @IBAction func indexChanged(sender: UISegmentedControl) {
        self.updateDepartureLabel()
    }
    
    /**
     Calculate the height for the table view cell at the given index.
     - parameter tableView:                            The table view.
     - parameter heightForRowAtIndexPath indexPath:    Row's index.
     - returns:                                        the cell height.
     */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 {
            let height = self.stopListLabel.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            return height < self.tableView.estimatedRowHeight ? self.tableView.estimatedRowHeight : height
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            let height = self.departureListLabel.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height +
                self.dayTypeSegmentController.frame.height + 8
            return height < 135 ? 135 : height
        }
        return 60.0
    }
    
    /**
     Searches for departures for a given route id.
     */
    private func loadDepartures() {
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.departureListLabel, animated: true)
        progressHUD.mode = .Indeterminate
        self.departures.findDepartures(withRouteId: currentRoute!.id) { error in
            if let error = error {
                self.showAlertMessageDialog(error.localizedDescription)
            } else {
                self.updateDepartureLabel()
                self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
            }
            MBProgressHUD.hideAllHUDsForView(self.departureListLabel, animated: true)
        }
    }
    
    /**
     Update departures label.
     */
    private func updateDepartureLabel() {
        self.departureListLabel.text = ""
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "HH':'mm"
        switch self.dayTypeSegmentController.selectedSegmentIndex {
        case 0:
            for departure in self.departures.weekdayDepartures {
                self.departureListLabel.text? += dateFormater.stringFromDate(departure)
                self.departureListLabel.text? += "  "
            }
        case 1:
            for departure in self.departures.saturdayDepartures {
                self.departureListLabel.text? += dateFormater.stringFromDate(departure)
                self.departureListLabel.text? += "  "
            }
        case 2:
            for departure in self.departures.sundayDepartures {
                self.departureListLabel.text? += dateFormater.stringFromDate(departure)
                self.departureListLabel.text? += "  "
            }
        default:
            break;
        }
        self.tableView.setNeedsDisplay()
    }
    
    /**
     Searches for stops for a given route id, and updates the stop list label.
     */
    private func loadStops() {
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.stopListLabel, animated: true)
        progressHUD.mode = .Indeterminate
        routeStopCollection.findStops(withRouteId: currentRoute!.id) { error in
            if let error = error {
                self.showAlertMessageDialog(error.localizedDescription)
                /*
                You could return here and reduce the depth by removing the else block
                */
            } else {
                for stop in self.routeStopCollection.stopNames {
                    if self.stopListLabel.text?.isEmpty == false {
                        self.stopListLabel.text? += " -> "
                    }
                    self.stopListLabel.text? += stop
                }
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
            }
            /*
            If you did like my previous comment, this line should be moved to the top of this block
            */
            MBProgressHUD.hideAllHUDsForView(self.stopListLabel, animated: true)
        }
    }
    
    /**
     Shown alert message.
     - parameter message:    the alert message.
     */
    private func showAlertMessageDialog(message: String) {
        let errorDialog = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        errorDialog.addAction(dismissAction)
        self.presentViewController(errorDialog, animated: true, completion: nil)
    }
    
}
