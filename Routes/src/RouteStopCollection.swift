//
//  RouteStopCollection.swift
//  Routes
//
//  Created by Marcone Magnus on 1/12/16.
//  Copyright © 2016 Marcone Magnus. All rights reserved.
//

import Foundation
import SwiftyJSON

class RouteStopCollection {
    
    var stopNames = [String]()
    
    let apiFetcher : APIDataFetcher = APIDataFetcher()
    
    func findStops(withRouteId routeId : Int, completionHandler: (NSError?) -> ()) {
        apiFetcher.findStops(byRouteId: routeId).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.stopNames.removeAll()
                    self.unwrapStops(fromJsonObject: json)
                    completionHandler(nil)
                }
            case .Failure(let error):
                completionHandler(error)
            }
        }
    }
    
    private func unwrapStops(fromJsonObject json : JSON) {
        for (_, subJson) : (String, JSON) in json["rows"] {
            let stop = subJson["name"].string!
            self.stopNames.append(stop)
            print(stop)
        }
    }
}