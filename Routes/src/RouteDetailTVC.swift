//
//  RouteDetailTVC.swift
//  Routes
//
//  Created by Marcone Magnus on 1/11/16.
//  Copyright © 2016 Marcone Magnus. All rights reserved.
//

import UIKit
import MBProgressHUD

class RouteDetailTVC: UITableViewController {
    
    var currentRoute : Route?
    let departures = DepartureCollection()
    let routeStopCollection = RouteStopCollection()

    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var modifiedLabel: UILabel!
    @IBOutlet weak var stopListLabel: UILabel!
    @IBOutlet weak var departureListLabel: UILabel!
    @IBOutlet weak var dayTypeSegmentController: UISegmentedControl!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.estimatedRowHeight = 90.0;
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = .MediumStyle
        routeName.text = currentRoute?.longName
        modifiedLabel.text = "Last Modified: " + dateFormater.stringFromDate((self.currentRoute?.lastModifiedDate)!)
        self.loadDepartures()
        self.loadStops()
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        self.updateDepartureLabel()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 {
            let height = self.stopListLabel.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            return height < self.tableView.estimatedRowHeight ? self.tableView.estimatedRowHeight : height
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            let height = self.departureListLabel.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height +
                self.dayTypeSegmentController.frame.height + 8
            return height < 120 ? 120 : height
        }
        return 60.0
    }
    
    private func loadDepartures() {
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.departureListLabel, animated: true)
        progressHUD.mode = .Indeterminate
        departures.findDepartures(withRouteId: currentRoute!.id!) { error in
            if error != nil{
                self.showAlertMessageDialog((error?.localizedDescription)!)
            } else {
                self.updateDepartureLabel()
            }
            MBProgressHUD.hideAllHUDsForView(self.departureListLabel, animated: true)
        }
    }
    
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
        self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
    }
    
    private func loadStops() {
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.stopListLabel, animated: true)
        progressHUD.mode = .Indeterminate
        routeStopCollection.findStops(withRouteId: currentRoute!.id!) { error in
            if error != nil {
                self.showAlertMessageDialog((error?.localizedDescription)!)
            } else {
                for stop in self.routeStopCollection.stopNames {
                    if self.stopListLabel.text?.isEmpty == false {
                        self.stopListLabel.text? += " -> "
                    }
                    self.stopListLabel.text? += stop
                }
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
            }
            MBProgressHUD.hideAllHUDsForView(self.stopListLabel, animated: true)
        }
    }
    
    private func showAlertMessageDialog(message: String) {
        let errorDialog = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        errorDialog.addAction(dismissAction)
        self.presentViewController(errorDialog, animated: true, completion: nil)
    }
    
}
