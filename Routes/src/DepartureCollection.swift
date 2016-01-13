//
//  DepartureCollection.swift
//  Routes
//
//  Created by Marcone Magnus on 1/12/16.
//  Copyright © 2016 Marcone Magnus. All rights reserved.
//

import Foundation
import SwiftyJSON

class DepartureCollection {
    
    var departures = [NSDate]()
    
    let apiFetcher : APIDataFetcher = APIDataFetcher()
    
    func findDepartures(withRouteId routeId : Int, completionHandler: (NSError?) -> ()) {
        apiFetcher.findDepartures(byRouteId: routeId).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.departures.removeAll()
                    self.unwrapDepartures(fromJsonObject: json)
                    completionHandler(nil)
                }
            case .Failure(let error):
                completionHandler(error)
            }
        }
    }
    
    private func unwrapDepartures(fromJsonObject json : JSON) {
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "HH':'mm"
        
        //print("JSON: \(json)")
        
        for (_, subJson) : (String, JSON) in json["rows"] {
            let date = dateFormater.dateFromString(subJson["time"].string!)!
            self.departures.append(date)
            print(dateFormater.stringFromDate(date) + " " + subJson["calendar"].string!)
        }
        //print(departures.count)
    }
}