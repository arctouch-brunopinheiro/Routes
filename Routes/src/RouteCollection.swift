//
//  RouteCollection.swift
//  Routes
//
//  Created by Marcone Magnus on 1/5/16.
//  Copyright © 2016 Marcone Magnus. All rights reserved.
//

import Foundation

class RouteCollection {
    
    var stopName : String
    
    var routes : [Route]
    
    init(withStopName stop: String) {
        self.stopName = stop;
        self.routes = [Route]()
    }
}
