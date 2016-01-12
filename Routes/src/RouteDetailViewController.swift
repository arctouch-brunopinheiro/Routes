//
//  RouteDetailViewController.swift
//  Routes
//
//  Created by Marcone Magnus on 1/11/16.
//  Copyright © 2016 Marcone Magnus. All rights reserved.
//

import UIKit

class RouteDetailViewController: UIViewController {

    @IBOutlet weak var routeName: UILabel!
    
    var currentRoute : Route?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        routeName.text = currentRoute?.longName
    }
}
