//
//  RouteCollection.swift
//  Routes
//
//  Created by Marcone Magnus on 1/5/16.
//  Copyright © 2016 Marcone Magnus. All rights reserved.
//

import Foundation

class RouteCollection {
    
    var stopName : String = ""
    
    var routes : [Route] = [Route]()
    
    let apiFetcher : APIDataFetcher = APIDataFetcher()
    
    func findRoutes(withStopName stopName : String) {
        apiFetcher.findRoutes(byStopName: stopName)
    }
}
